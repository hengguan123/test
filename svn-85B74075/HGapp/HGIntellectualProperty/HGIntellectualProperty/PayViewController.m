//
//  PayViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/22.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PayViewController.h"
#import "PaymentResultsView.h"
@interface PayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIButton *wechatSelBtn;
@property (weak, nonatomic) IBOutlet UIButton *aliSelBtn;
@property (weak, nonatomic) IBOutlet UILabel *bankInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *aliInfoLab;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end

@implementation PayViewController
{
    BOOL _payResult;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    CGFloat funt = 12/375.0*ScreenWidth;
    self.aliInfoLab.font = [UIFont systemFontOfSize:funt];
    self.bankInfoLab.font = [UIFont systemFontOfSize:funt];

   
    self.priceLab.text = [NSString stringWithFormat:@"%@元",self.model.orderPrice];
    
    _payResult = NO;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resultCloseNiti) name:ResultViewHiddenNoti object:nil];
    
//
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)tap1:(id)sender {
    self.wechatSelBtn.selected = YES;
    self.aliSelBtn.selected = NO;
    self.payBtn.hidden = NO;
    [self.payBtn setTitle:[NSString stringWithFormat:@"微信支付%@元",self.model.orderPrice] forState:UIControlStateNormal];
}

- (IBAction)tap2:(id)sender {
    self.wechatSelBtn.selected = NO;
    self.aliSelBtn.selected = YES;
    self.payBtn.hidden = NO;
    [self.payBtn setTitle:[NSString stringWithFormat:@"支付宝支付%@元",self.model.orderPrice] forState:UIControlStateNormal];
}
- (IBAction)pay:(id)sender {
    if (self.wechatSelBtn.isSelected) {
        if (self.model.orderNo) {
            [RequestManager wechatPayWithSuperOrderNo:self.model.orderNo price:self.model.orderPrice errandTitle:self.model.title isInside:self.isInside?:@"0" SuccessHandler:^(NSDictionary *json) {
                PayReq *request = [[PayReq alloc] init];
                request.partnerId = [json objectForKey:@"partnerid"];
                request.openID = [json objectForKey:@"appid"];
                NSString *prepayid = [json objectForKey:@"prepayid"];
                if ([prepayid isKindOfClass:[NSNull class]]) {
                    [SVProgressHUD showErrorWithStatus:@"创建支付订单失败"];
                    return ;
                }
                request.prepayId = prepayid;
                request.package = [json objectForKey:@"package"];
                request.nonceStr = [json objectForKey:@"noncestr"];
                request.timeStamp = [[json objectForKey:@"timestamp"] intValue];
                request.sign = [json objectForKey:@"sign"];
                [WXApi sendReq:request];
                [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(weChatPayNoti:) name:WeChatPayNoti object:nil];
            } errorHandler:^(NSError *error) {
                
            }];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"获取支付订单失败"];
        }
    }
    else
    {
//        [SVProgressHUD showInfoWithStatus:@"暂缓开通"];
        [RequestManager alipayWithOrderId:self.model.orderId isInside:self.isInside?:@"0" SuccessHandler:^(NSString *orderStr) {
            [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"HGIPAPP" callback:^(NSDictionary *resultDic) {
                NSLog(@"reslut = %@",resultDic);
                NSString *resultStatus = [resultDic objectForKey:@"resultStatus"];
                if ([resultStatus isEqualToString:@"9000"]) {
                    [self getAlipaySttus];
                }
                else if([resultStatus isEqualToString:@"6004"])
                {
                    [self getAlipaySttus];
                }
                else if([resultStatus isEqualToString:@"8000"])
                {
                    [self getAlipaySttus];
                }
                else if([resultStatus isEqualToString:@"4000"])
                {
                    [PaymentResultsView showWithInfo:@"支付失败"];
                }
                else if([resultStatus isEqualToString:@"6001"])
                {
                    [NetPromptBox showWithInfo:@"用户取消支付" stayTime:2];
                }
                else if([resultStatus isEqualToString:@"6002"])
                {
                    [NetPromptBox showWithInfo:@"网络连接错误" stayTime:2];
                }
                else if([resultStatus isEqualToString:@"其他"])
                {
                    [NetPromptBox showWithInfo:@"未知错误" stayTime:2];
                }
            }];
        } errorHandler:^(NSError *error) {
            
        }];
    }
}

-(void)getAlipaySttus
{
    [RequestManager getAlipayResultWithOrderNo:self.model.orderNo SuccessHandler:^(NSDictionary *result) {
        NSDictionary *statusDict = [result objectForKey:@"alipay_trade_query_response"];
        if ([[statusDict objectForKey:@"trade_status"]isEqualToString:@"TRADE_SUCCESS"]) {
            _payResult = YES;
            [PaymentResultsView showWithInfo:@"支付成功"];
        }
        else
        {
            [PaymentResultsView showWithInfo:@"支付失败"];
        }
    } errorHandler:^(NSError *error) {
        
    }];
}

-(void)weChatPayNoti:(NSNotification *)noti
{
    PayResp *response = [noti.userInfo objectForKey:@"info"];
    switch(response.errCode){
        case WXSuccess:
            //服务器端查询支付通知或查询API返回的结果再提示成功
        {
            [LoadingManager show];
            [RequestManager getPayResultWithOrderNum:self.model.orderNo successHandler:^(BOOL success) {
                [LoadingManager dismiss];
                if (success) {
                    _payResult = YES;
                    [PaymentResultsView showWithInfo:@"支付成功"];
                }
                else
                {
                    [PaymentResultsView showWithInfo:@"支付失败"];
                }
            } errorHandler:^(NSError *error) {
                
            }];
           
        }
            break;
        default:
        {
            [PaymentResultsView showWithInfo:@"支付失败"];
        }
            break;
    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:WeChatPayNoti object:nil];
}

-(void)resultCloseNiti
{
    if (_payResult) {
        if (self.fromList) {
            [self.navigationController popToViewController:self.fromList animated:YES];

        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}




@end
