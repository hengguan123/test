//
//  ChangeNickNameViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/6.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ChangeNickNameViewController.h"

@interface ChangeNickNameViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;

@end

@implementation ChangeNickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.nickNameTextField.text = [AppUserDefaults share].userName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)clear:(id)sender {
    self.nickNameTextField.text = @"";
}
- (IBAction)save:(id)sender {
    if ([self.nickNameTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"昵称不能为空"];
    }
    else if ([self.nickNameTextField.text containsString:@" "])
    {
        [SVProgressHUD showInfoWithStatus:@"昵称不能包含空格"];
    }
    else
    {
        [RequestManager changeUserInfoWithUsrAlias:self.nickNameTextField.text successHandler:^(BOOL success) {
            [AppUserDefaults share].userName = self.nickNameTextField.text;
            [self.navigationController popViewControllerAnimated:YES];
            [NetPromptBox showWithInfo:@"昵称修改成功" stayTime:2];
        } errorHandler:^(NSError *error) {
            
        }];
        if ([MyApp.userInfo.usrType isEqualToString:@"1"]&&MyApp.userInfo.facilitatorId) {
            [RequestManager changeAgentInfoWithNickname:self.nickNameTextField.text SuccessHandler:^(BOOL success) {
                
            } errorHandler:^(NSError *error) {
                
            }];
        }
        
    }
}
- (IBAction)valueChange:(UITextField *)sender {
    if (sender.text.length>12) {
        [SVProgressHUD showInfoWithStatus:@"昵称不得超过12个字"];
        sender.text = [sender.text substringToIndex:12];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.nickNameTextField resignFirstResponder];
}

@end
