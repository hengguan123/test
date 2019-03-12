//
//  BundPhoneViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/2/2.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "BundPhoneViewController.h"

@interface BundPhoneViewController ()
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@end

@implementation BundPhoneViewController
{
    NSTimer *_timer;
    NSInteger _second;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"绑定手机号";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)starTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _second = 59;
    self.codeBtn.enabled = NO;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}
-(void)timerAction{
    _second -- ;
    if (_second<=0) {
        [_timer invalidate];
        _timer = nil;
        self.codeBtn.enabled = YES;
    }
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds",_second] forState:UIControlStateDisabled];
}

- (IBAction)getCode:(id)sender {
    if ([GGTool isMobileNumber:self.phoneTextField.text]) {
        [RequestManager getVerificationCodeWithPhoneNum:self.phoneTextField.text type:@"17" successHandler:^(BOOL success) {
            [self.codeBtn setTitle:@"59s" forState:UIControlStateDisabled];
            [self starTimer];
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:@"手机号格式不正确"];
    }
}

- (IBAction)sure:(id)sender {
    [RequestManager bindWithwxAccount:nil qqAccount:nil usrAccount:self.phoneTextField.text nodeCode:self.codeTextField.text successHandler:^(BOOL success) {
        [NetPromptBox showWithInfo:@"绑定成功" stayTime:2];
        AppUserDefaults.share.phone = self.phoneTextField.text;
        [self back];
    } errorHandler:^(NSError *error) {
        
    }];
}


@end
