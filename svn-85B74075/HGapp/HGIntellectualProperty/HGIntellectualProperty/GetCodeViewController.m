//
//  GetCodeViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/2/1.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "GetCodeViewController.h"

@interface GetCodeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (weak, nonatomic) IBOutlet UITextField *codeTextfield;

@end

@implementation GetCodeViewController
{
    NSTimer *_timer;
    NSInteger _second;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手机号验证";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    [self getCode:nil];
    
}

-(void)starTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    self.btn.enabled = NO;
    _second = 59;
    [self.btn setTitle:@"59s" forState:UIControlStateDisabled];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
}

-(void)timerAction{
    _second -- ;
    if (_second<=0) {
        [_timer invalidate];
        _timer = nil;
        self.btn.enabled = YES;
    }
    [self.btn setTitle:[NSString stringWithFormat:@"%lds",_second] forState:UIControlStateDisabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)getCode:(id)sender {
    
    [RequestManager getVerificationCodeWithPhoneNum:MyApp.userInfo.usrAccount type:@"16" successHandler:^(BOOL success) {
        if (success) {
            [self starTimer];
        }
    } errorHandler:^(NSError *error) {
        
    }];
}
- (IBAction)submit:(id)sender {
    
    [RequestManager unbundledWithwxAccount:nil qqAccount:nil usrAccount:MyApp.userInfo.usrAccount nodeCode:self.codeTextfield.text successHandler:^(BOOL success) {
        [NetPromptBox showWithInfo:@"解绑成功" stayTime:2];
        AppUserDefaults.share.phone = nil;
        [self back];
    } errorHandler:^(NSError *error) {
        
    }];
}

@end
