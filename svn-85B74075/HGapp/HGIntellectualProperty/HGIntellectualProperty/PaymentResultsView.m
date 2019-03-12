//
//  PaymentResultsView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/30.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PaymentResultsView.h"

@interface PaymentResultsView ()

@property (nonatomic,strong)UILabel *infoLab;

@end

@implementation PaymentResultsView
{
    UIView *_showView;
    
}
-(instancetype)init
{
    if (self = [super init]) {
        self = [[PaymentResultsView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        self.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        
        _showView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 230, 140)];
        _showView.center = self.center;
        _showView.layer.cornerRadius = 10;
        _showView.layer.masksToBounds = YES;
        _showView.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self addSubview:_showView];
        _infoLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 45,230, 22)];
        _infoLab.textColor = MainColor;
        _infoLab.font = [UIFont systemFontOfSize:18];
        _infoLab.textAlignment = 1;
//        _infoLab.backgroundColor = [UIColor redColor];
        [_showView addSubview:_infoLab];
        
        UIButton *closeBtn = [[UIButton alloc]initWithFrame:CGRectMake(176, 0, 32, 39)];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
        [_showView addSubview:closeBtn];
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 140-35, 230, 35)];
        btn.backgroundColor = MainColor;
        [btn setTitle:@"确定" forState:UIControlStateNormal];
        [_showView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)btnClick
{
    [[NSNotificationCenter defaultCenter]postNotificationName:ResultViewHiddenNoti object:nil];
    [self removeFromSuperview];
}
+(PaymentResultsView *)shareView
{
    static PaymentResultsView *view = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        view = [[PaymentResultsView alloc] init];
    });
    return view;
}

+(void)showWithInfo:(NSString *)info
{
    [MyApp.window addSubview:[self shareView]];
    [self shareView].infoLab.text = info;
}

-(void)tap
{
    [self removeFromSuperview];
    [[NSNotificationCenter defaultCenter]postNotificationName:ResultViewHiddenNoti object:nil];
}
@end
