//
//  LoginViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/2.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "LoginViewController.h"
#import "RequestURL.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIButton *verificationCodeBtn;
@property (nonatomic,strong) NSTimer *timer_60s;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end

@implementation LoginViewController
{
    NSInteger _sceond;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
     [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"navigationBarBg"]]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    self.navigationItem.title = @"登录";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    [self.phoneTextField addTarget:self action:@selector(phoneChange) forControlEvents:UIControlEventEditingChanged];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}
- (void)back {
    [self.phoneTextField resignFirstResponder];
    [self.verificationCodeTextField resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.phoneTextField resignFirstResponder];
    [self.verificationCodeTextField resignFirstResponder];
}
- (void)phoneChange
{
    if (self.phoneTextField.text.length == 11) {
        if (_timer_60s.isValid) {
            
        }
        else
        {
            self.verificationCodeBtn.enabled = YES;
            self.verificationCodeBtn.backgroundColor = MainColor;
        }
    }
    else
    {
        if (_timer_60s.isValid) {
            
        }
        else
        {
            self.verificationCodeBtn.enabled = NO;
            self.verificationCodeBtn.backgroundColor = UIColorFromRGB(0xDCDCDC);
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)addTimer
{
    _timer_60s=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
}
- (void)removeTimer
{
    [_timer_60s invalidate];
    _timer_60s=nil;
}
- (void)countDown
{
    _sceond--;
    if (_sceond>0) {
        
        [self.verificationCodeBtn setTitle:[NSString stringWithFormat:@"%lds重新获取",_sceond] forState:UIControlStateDisabled];
    }
    else
    {
        self.verificationCodeBtn.enabled=YES;
        self.verificationCodeBtn.backgroundColor = MainColor ;
        [self removeTimer];
    }
}


#pragma mark xib  action
- (IBAction)btnClick:(UIButton *)sender {
    WebViewController *vc = [[WebViewController alloc]init];
    vc.titleStr = @"用户协议";
//    vc.urlStr= [[NSBundle mainBundle] pathForResource:@"agreement" ofType:@"html"];
    vc.urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/faci/userAgree"];
    
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)getVerificationCode:(id)sender {
    if ([GGTool isMobileNumber:self.phoneTextField.text]) {
        NSLog(@"获取验证码");
        [RequestManager getVerificationCodeWithPhoneNum:self.phoneTextField.text type:@"2" successHandler:^(BOOL success) {
            if (success) {
                _sceond=60;
                self.verificationCodeBtn.enabled = NO;
                self.verificationCodeBtn.backgroundColor = UIColorFromRGB(0xDCDCDC) ;
                [self.verificationCodeBtn setTitle:@"60s重新获取" forState:UIControlStateDisabled];
                [self addTimer];
            }
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"手机号格式有误"];
    }
}

- (IBAction)login:(id)sender {
    [self.phoneTextField resignFirstResponder];
    [self.verificationCodeTextField resignFirstResponder];
    if ([self.phoneTextField.text isEqualToString:@""]||[self.verificationCodeTextField.text isEqualToString:@""]) {
        [SVProgressHUD showInfoWithStatus:@"输入不能为空"];
    }
    else
    {
        if (self.selectBtn.selected) {
            [SVProgressHUD showInfoWithStatus:@"请勾选用户协议"];
        }
        else
        {
            [LoadingManager show];
            [RequestManager loginWithPhoneNum:self.phoneTextField.text vcode:self.verificationCodeTextField.text successHandler:^(NSDictionary *dict) {
                if (dict) {
                    AppUserDefaults.share.login = YES;
                    AppUserDefaults.share.usrId = [dict objectForKey:@"usrId"];
                    AppUserDefaults.share.userName = [dict objectForKey:@"usrAlias"];
                    AppUserDefaults.share.isInside = [dict objectForKey:@"isInside"];
                    AppUserDefaults.share.specialUser = [[dict objectForKey:@"usrType"]isEqualToString:@"1"];
                    AppUserDefaults.share.phone = [dict objectForKey:@"usrAccount"];
                    [SVProgressHUD showSuccessWithStatus:@"登陆成功!"];
                    [LoadingManager dismiss];
                    [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"用户%@",[AppUserDefaults share].usrId]];
                    NSSet *set = [[NSSet alloc]initWithObjects:[NSString stringWithFormat:@"%@",[dict objectForKey:@"usrId"]], nil];
                    [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                        if (iResCode==0) {
                            
                        }
                        else
                        {
                            [JPUSHService setTags:set completion:nil seq:2];
                        }
                    } seq:1];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:LoginNodti object:nil];
                }
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
}
- (IBAction)select:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)WeChat:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
    
            if (error) {
                [LoadingManager dismiss];
            } else {
                UMSocialUserInfoResponse *resp = result;
                [LoadingManager show];
                [RequestManager loginWithUid:resp.unionId userName:resp.name noType:@"2" portraitUrl:resp.iconurl successHandler:^(NSDictionary *dict) {
                    AppUserDefaults.share.login = YES;
                    AppUserDefaults.share.usrId = [dict objectForKey:@"usrId"];
                    
                    AppUserDefaults.share.isInside = [dict objectForKey:@"isInside"];
                    AppUserDefaults.share.userName = [dict objectForKey:@"usrAlias"];
                    AppUserDefaults.share.specialUser = [[dict objectForKey:@"usrType"]isEqualToString:@"1"];
                    NSString *str = [dict objectForKey:@"usrAccount"];
                    if ([str isKindOfClass:[NSNull class]]) {
                        AppUserDefaults.share.phone = nil;
                    }
                    else
                    {
                        AppUserDefaults.share.phone = str;
                    }
                    [SVProgressHUD showSuccessWithStatus:@"登陆成功!"];
                    [LoadingManager dismiss];
                    [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"用户%@",[AppUserDefaults share].usrId]];
                    NSSet *set = [[NSSet alloc]initWithObjects:[NSString stringWithFormat:@"%@",[dict objectForKey:@"usrId"]], nil];
                    [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                        if (iResCode==0) {
                            
                        }
                        else
                        {
                            [JPUSHService setTags:set completion:nil seq:2];
                        }
                    } seq:1];
                     
                     
                
                    [self dismissViewControllerAnimated:YES completion:nil];
                    [[NSNotificationCenter defaultCenter]postNotificationName:LoginNodti object:nil];
                } errorHandler:^(NSError *error) {
                    
                }];
            }
    }];
}
- (IBAction)QQ:(id)sender {
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [LoadingManager dismiss];
        } else {
            UMSocialUserInfoResponse *resp = result;
            [LoadingManager show];
            [RequestManager loginWithUid:resp.unionId userName:resp.name noType:@"1" portraitUrl:resp.iconurl successHandler:^(NSDictionary *dict) {
                AppUserDefaults.share.login = YES;
                AppUserDefaults.share.usrId = [dict objectForKey:@"usrId"];
                AppUserDefaults.share.isInside = [dict objectForKey:@"isInside"];
                AppUserDefaults.share.userName = [dict objectForKey:@"usrAlias"];
                AppUserDefaults.share.specialUser = [[dict objectForKey:@"usrType"]isEqualToString:@"1"];
                NSString *str = [dict objectForKey:@"usrAccount"];
                if ([str isKindOfClass:[NSNull class]]) {
                    AppUserDefaults.share.phone = nil;
                }
                else
                {
                    AppUserDefaults.share.phone = str;
                }
                [SVProgressHUD showSuccessWithStatus:@"登陆成功!"];
                [LoadingManager dismiss];
                NSSet *set = [[NSSet alloc]initWithObjects:[NSString stringWithFormat:@"%@",[dict objectForKey:@"usrId"]], nil];
                [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"用户%@",[AppUserDefaults share].usrId]];
                [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                    if (iResCode==0) {
                        
                    }
                    else
                    {
                        [JPUSHService setTags:set completion:nil seq:2];
                    }
                } seq:1];
                [self dismissViewControllerAnimated:YES completion:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:LoginNodti object:nil];
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }];
    
}

@end
