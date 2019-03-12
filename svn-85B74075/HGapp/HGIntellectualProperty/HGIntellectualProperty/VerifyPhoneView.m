//
//  VerifyPhoneView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/3/21.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "VerifyPhoneView.h"

@interface VerifyPhoneView()

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;



@end

@implementation VerifyPhoneView
{
    NSTimer *_timer;
    NSInteger _sceound;
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)show
{
    [MyApp.window addSubview:self];
    [self startTimer];
}
-(void)dismiss{
    [self removeFromSuperview];
}

- (IBAction)getCode:(id)sender {
    if ([GGTool isMobileNumber:self.phoneTextField.text]) {
        [RequestManager getVerificationCodeWithPhoneNum:self.phoneTextField.text type:@"1" successHandler:^(BOOL success) {
            [self startTimer];
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        [SVProgressHUD showInfoWithStatus:@"请输入正确手机号"];
    }
}
- (IBAction)sure:(id)sender {
    
}

- (void)startTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    self.codeBtn.enabled = NO;
    _sceound = 59;
    [self.codeBtn setTitle:@"59s" forState:UIControlStateDisabled];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(cutDown) userInfo:nil repeats:YES];
}

-(void)cutDown
{
    _sceound -- ;
    [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds",_sceound] forState:UIControlStateDisabled];
    
    if (_sceound <=0) {
        [_timer invalidate];
        _timer = nil;
        self.codeBtn.enabled = YES;
    }
}

@end
