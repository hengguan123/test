//
//  PopBankInfoView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/8/26.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "PopBankInfoView.h"

@interface PopBankInfoView ()

@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankCardIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *bankTextField;
@property (weak, nonatomic) IBOutlet UITextField *totalPayTextField;


@end

@implementation PopBankInfoView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"PopBankInfoView" owner:nil options:nil] lastObject];
        self.frame = frame;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)show{
    [MyApp.window addSubview:self];
}

-(void)dismiss{
    [self removeFromSuperview];
}

@end
