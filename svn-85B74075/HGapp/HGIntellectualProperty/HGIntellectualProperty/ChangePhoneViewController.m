//
//  ChangePhoneViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/6.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ChangePhoneViewController.h"

@interface ChangePhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.phoneTextField.text = [AppUserDefaults share].phone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clear:(id)sender {
    self.phoneTextField.text = @"";
}
- (IBAction)save:(id)sender {
    if ([GGTool isMobileNumber:self.phoneTextField.text]) {
        [RequestManager changePhone:self.phoneTextField.text detailsId:MyApp.userInfo.detailsId successHandler:^(BOOL success) {
            [AppUserDefaults share].phone = self.phoneTextField.text;
            [self.navigationController popViewControllerAnimated:YES];
            [NetPromptBox showWithInfo:@"手机号修改成功" stayTime:2];
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"请输入正确格式手机号"];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
}
@end
