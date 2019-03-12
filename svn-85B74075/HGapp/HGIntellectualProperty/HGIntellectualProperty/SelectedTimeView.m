//
//  SelectedTimeView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SelectedTimeView.h"

#define TimeBgViewHeight 254
@interface SelectedTimeView ()

@property(nonatomic,strong)UIView *hiddenView;

@end

@implementation SelectedTimeView
{
    UIView *_parentView;
    UIDatePicker *_datePicker;
}
-(instancetype)initWithParentView:(UIView *)parentView
{
    if (self = [super initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, TimeBgViewHeight)]) {
        self.backgroundColor = [UIColor whiteColor];
        _parentView = parentView;
        [parentView addSubview:self];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 40, 30)];
        [cancelBtn addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:cancelBtn];
        
        UIButton *sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-50, 5, 40, 30)];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [sureBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [self addSubview:sureBtn];
        
        _datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0,40,ScreenWidth,214)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
        //        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
//        _datePicker1.minimumDate = [NSDate date];
        [self addSubview:_datePicker];
        
    }
    return self;
}

-(void)show
{
   
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, ScreenHeight-TimeBgViewHeight, ScreenWidth, TimeBgViewHeight);
    } completion:^(BOOL finished) {
        [_parentView addSubview:self.hiddenView];
    }];
}
-(UIView *)hiddenView
{
    if (!_hiddenView) {
        _hiddenView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-TimeBgViewHeight)];
        _hiddenView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self  action:@selector(tap)];
        [_hiddenView addGestureRecognizer:tap];
    }
    return _hiddenView;
}
-(void)tap
{
    [self.hiddenView removeFromSuperview];
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, ScreenHeight, ScreenWidth, TimeBgViewHeight);
    } completion:^(BOOL finished) {
        
    }];
}
-(void)hidden
{
    [self tap];
}
-(void)sure
{
    [self hidden];
    NSDate *theDate = _datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:theDate];
    if (self.selectedTimeBlock) {
        self.selectedTimeBlock(dateStr);
    }
}
@end
