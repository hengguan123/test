//
//  RobbedDetialTableViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "RobbedDetialTableViewController.h"
#import "HandleTableViewController.h"
#import "ProgressListViewController.h"
#import "WriteReviewTableViewController.h"
#import "PayViewController.h"
#import "AgentDetialTableViewController.h"


@interface RobbedDetialTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *cityLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *grabTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *domainLab;
@property (weak, nonatomic) IBOutlet UILabel *classLab;
@property (weak, nonatomic) IBOutlet UILabel *subClassLab;

@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UIButton *functionBtn;
@property (weak, nonatomic) IBOutlet UILabel *faciName;


@end

@implementation RobbedDetialTableViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    if (self.type == GrabDetialFunctionTypeHandle) {
        if ([self.model.errandStatus isEqualToString:@"CSZT01-02"]||[self.model.errandStatus isEqualToString:@"CSZT01-06"]||[self.model.errandStatus isEqualToString:@"CSZT01-07"]) {
            [self.functionBtn setTitle:@"办理进度" forState:UIControlStateNormal];
        }
        else
        {
            [self.functionBtn setTitle:@"办理" forState:UIControlStateNormal];
        }
        
    }
    else if (self.type == GrabDetialFunctionTypeComment)
    {
        [self.functionBtn setTitle:@"评价" forState:UIControlStateNormal];
    }
    else if (self.type == GrabDetialFunctionTypeProgress){
        
        [self.functionBtn setTitle:@"查看进度" forState:UIControlStateNormal];
    }
    else if (self.type == GrabDetialFunctionTypePay)
    {
        [self.functionBtn setTitle:@"去支付" forState:UIControlStateNormal];
    }
    if (self.model)
    {
        self.titleLab.text = self.model.errandTitle;
        self.priceLab.text = [NSString stringWithFormat:@"%@",self.model.price ];
        self.userName.text = self.model.usrName;
        self.cityLab.text = self.model.dwellAddrName;
        self.timeLab.text = self.model.createTime;
        self.grabTimeLab.text = self.model.robTime;
        self.classLab.text = self.model.errandTypeName;
        self.subClassLab.text = self.model.busiTypeName;
        self.domainLab.text = self.model.domainName;
        if (self.model.remark) {
            self.remarkTextView.text = self.model.remark;
        }
        self.faciName.text = self.model.faciName;
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)ask:(id)sender {
    NSLog(@"咨询平台");
    
    [self consultationPlatform];
    
}

- (void)deleteErrand
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"您确认撤销发布并删除此差事吗" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"删除然后刷新");
        [RequestManager deleteErrandWithErrandId:self.model.errandId successHandler:^(BOOL success) {
            [SVProgressHUD showSuccessWithStatus:@"删除差事成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } errorHandler:^(NSError *error) {
            
        }];
    }];
    [alert addAction:action2];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)consultationPlatform
{
    WebViewController *vc= [[WebViewController alloc]init];
    vc.titleStr = @"咨询平台";
    vc.urlStr = CustomerServiceUrl;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)functionClick:(id)sender {
    if (self.type == GrabDetialFunctionTypeHandle) {
        NSLog(@"办理");
        if ([self.model.errandStatus isEqualToString:@"CSZT01-02"]||[self.model.errandStatus isEqualToString:@"CSZT01-06"]||[self.model.errandStatus isEqualToString:@"CSZT01-07"]) {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ProgressListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProgressListViewController"];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            if([self.model.errandStatus isEqualToString:@"CSZT01-03"])
            {
                [SVProgressHUD showInfoWithStatus:@"未支付差事，无法办理"];
            }
            else
            {
                [self performSegueWithIdentifier:@"GrabDetailPushHandle" sender:self];
            }
        }
    }
    else if (self.type == GrabDetialFunctionTypeComment)
    {
        NSLog(@"评价");
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WriteReviewTableViewController *vc = [story instantiateViewControllerWithIdentifier:@"WriteReviewTableViewController"];
        vc.model = self.model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (self.type == GrabDetialFunctionTypeProgress){
        
        NSLog(@"进度");
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProgressListViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"ProgressListViewController"];
        vc.model = self.model;
        vc.fromList = self.fromList;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (self.type == GrabDetialFunctionTypePay)
    {
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        PayViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"PayViewController"];
//        vc.model = self.model;
//        vc.fromList = self.fromList;
//        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"GrabDetailPushHandle"]) {
        HandleTableViewController *vc = segue.destinationViewController;
        vc.fromList = self.fromList;
        vc.model = self.model;
    }
//    else if ([segue.identifier isEqualToString:@"ErrandDetailPushFaciDetail"])
//    {
//        AgentDetialTableViewController *vc = segue.destinationViewController;
//        vc.usrId = self.model.faciId;
//    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 11;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        HTMLViewController *view = [[HTMLViewController alloc]init];
        view.htmlUrl = [HTTPURL stringByAppendingFormat:@"/faci/faciInfo?faciId=%@&phone=%@&code=%@&code1=%@",self.model.faciId,[AppUserDefaults share].phone,@"",@""];
        view.titleStr = @"代理人详情";
        //        view.canShare = YES;
        view.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:view animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 44;
    }
    else if (indexPath.row == 1)
    {
        return 70;
    }
    else if (indexPath.row == 2)
    {
        return 54;
    }
    else if (indexPath.row == 3)
    {
        return 54;
    }
    else if (indexPath.row == 4)
    {
        return 54;
    }
    else if (indexPath.row == 5)
    {
        return 54;
    }
    else if (indexPath.row == 6)
    {
        return 54;
    }
    else if (indexPath.row == 7)
    {
        if ([self.model.errandType isEqualToString:TrademarkCode]||[self.model.errandType isEqualToString:CopyrightCode]) {
            return 0;
        }
        else
        {
            return 54;
        }
    }
    else if (indexPath.row == 8)
    {
        return 54;
    }
    else if (indexPath.row == 9)
    {
        return 54;
    }
    else if (indexPath.row == 10)
    {
        return 94;
    }
    return 0;
}

- (IBAction)call:(id)sender {
    
    UIAlertController *alertvc = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入当前使用手机号" preferredStyle:UIAlertControllerStyleAlert];
    //定义第一个输入框；
    [alertvc addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入您手机号";
        textField.textAlignment = 1;
        textField.keyboardType = UIKeyboardTypeNumberPad;
        if ([AppUserDefaults.share.phone isEqualToString:@""]||AppUserDefaults.share.phone==nil) {
            
        }
        else
        {
            textField.text = AppUserDefaults.share.phone;
        }
    }];
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *phoneTextField = alertvc.textFields.firstObject;
        if ([GGTool isMobileNumber:phoneTextField.text]) {
            [LoadingManager show];
            NSString *callPhone;
            if ([self.model.usrId isEqualToNumber:[AppUserDefaults share].usrId]) {
                callPhone = self.model.faciPhone;
            }
            else
            {
                callPhone = self.model.phone?self.model.phone:@"";
            }
            [RequestManager callDoublePhoneWithPhone:phoneTextField.text call:callPhone successHandler:^(BOOL success) {
                [LoadingManager dismiss];
                [SVProgressHUD showSuccessWithStatus:@"呼叫申请成功，请等待呼叫"];
            } errorHandler:^(NSError *error) {
                
            }];
        }
        else
        {
            [SVProgressHUD showInfoWithStatus:@"请输入正确手机号"];
        }
        
        
    } ];
    UIAlertAction *cancel =[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertvc addAction:sure];
    [alertvc addAction:cancel];
    [self presentViewController:alertvc animated:YES completion:^{
        
    }];
    
}



@end
