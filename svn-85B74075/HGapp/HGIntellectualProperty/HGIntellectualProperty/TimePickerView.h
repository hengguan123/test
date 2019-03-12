//
//  TimePickerView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimePickerView : UIView

@property(nonatomic,assign,readonly,getter=isShow)BOOL show;
@property(nonatomic,copy)void(^selectedTimeBlock)(NSString *timeStr);
-(void)show;
-(void)hidden;


@end
