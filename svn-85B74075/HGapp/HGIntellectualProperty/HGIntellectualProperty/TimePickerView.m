//
//  TimePickerView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "TimePickerView.h"

@implementation TimePickerView
{
    CGRect _frame;
    UIButton *_cancelBtn,*_sureBtn;
    UIDatePicker *_datePicker;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _frame = frame;
        _cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn setTitleColor:MainColor forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_cancelBtn];
        
        _sureBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-60, 0, 60, 30)];
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sureBtn setTitleColor:MainColor forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sure:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sureBtn];
        
        _datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0,32,ScreenWidth,216)];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh_CN"];
//        [_datePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
        _datePicker.minimumDate = [NSDate date];
        [self addSubview:_datePicker];
    }
    return self;
}

//- (void)dateChange:(UIDatePicker *)datePicker
//
//{
//    
//}

-(void)show
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, _frame.origin.y-_frame.size.height, _frame.size.width, _frame.size.height);
    } completion:^(BOOL finished) {
        _show = YES;
    }];
}

-(void)hidden
{
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = _frame;
    } completion:^(BOOL finished) {
        _show = NO;
        [self removeFromSuperview];
    }];
}

-(void)cancel:(UIButton *)btn
{
    [self hidden];
}
-(void)sure:(UIButton *)btn
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
