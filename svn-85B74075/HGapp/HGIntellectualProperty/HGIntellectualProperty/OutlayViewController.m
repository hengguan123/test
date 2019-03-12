//
//  OutlayViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/26.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "OutlayViewController.h"

@interface OutlayViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *bankCardNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankOpenTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankLocaleTextField;
@property (weak, nonatomic) IBOutlet UITextField *usrRealNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *optMoneyTextField;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLab;
@property (weak, nonatomic) IBOutlet UILabel *caseLab;

@property (nonatomic,strong)NSDictionary *dict;

@end

@implementation OutlayViewController
{
    NSInteger _cashMoney;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    _cashMoney = 0;
//    self.bankCardNoTextField.text = self.bankCardNo;
//    self.bankOpenTextField.text = self.bankOpen;
//    self.bankLocaleTextField.text = self.bankLocale;
    [self loadData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}
- (void)loadData
{
    [RequestManager checkMoneySuccessHandler:^(NSDictionary *dict) {
        self.dict = dict;
    } errorHandler:^(NSError *error) {
        
    }];
}
-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    NSString *total = [NSString stringWithFormat:@"总额 %@",[dict objectForKey:@"soldPay"]];
    self.totalMoneyLab.textColor = MainColor;
    self.totalMoneyLab.font = [UIFont systemFontOfSize:18];
    // 创建 NSMutableAttributedString
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:total];
    
    // 设置字体和设置字体的范围
    [attrStr addAttribute:NSFontAttributeName
                    value:[UIFont systemFontOfSize:12.0f]
                    range:NSMakeRange(0, 2)];
    // 添加文字颜色
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:UIColorFromRGB(0x666666)
                    range:NSMakeRange(0, 2)];
    self.totalMoneyLab.attributedText = attrStr;
    _cashMoney =[[dict objectForKey:@"soldPay"]integerValue]-[[dict objectForKey:@"unWithdrawPrice"]integerValue];
    self.caseLab.text = [NSString stringWithFormat:@"(可提现%ld)",(long)_cashMoney];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)submit:(id)sender {
    if ([self.bankCardNoTextField.text isEqualToString:@""]||[self.bankOpenTextField.text isEqualToString:@""]||[self.bankLocaleTextField.text isEqualToString:@""]||[self.usrRealNameTextField.text isEqualToString:@""]||[self.optMoneyTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"输入不能为空"];
    }
    else if ([self.optMoneyTextField.text integerValue]>_cashMoney)
    {
        [SVProgressHUD showErrorWithStatus:@"提现金额不得超出可提现金额"];
    }
    else
    {
        [LoadingManager show];
        [RequestManager outlayWithBankCardNo:self.bankCardNoTextField.text bankOpen:self.bankOpenTextField.text bankLocale:self.bankLocaleTextField.text usrRealName:self.usrRealNameTextField.text price:[self.optMoneyTextField.text intValue] successHandler:^(BOOL success) {
            [LoadingManager dismiss];
            [SVProgressHUD showSuccessWithStatus:@"提现申请成功，我们将在7个工作日内打款到提现账户，请注意查收"];
            [self loadData];
            
            self.optMoneyTextField.text = @"";
            
        } errorHandler:^(NSError *error) {
            
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.optMoneyTextField resignFirstResponder];
    [self.usrRealNameTextField resignFirstResponder];
    [self.bankLocaleTextField resignFirstResponder];
    [self.bankOpenTextField resignFirstResponder];
    [self.bankCardNoTextField resignFirstResponder];
}

@end
