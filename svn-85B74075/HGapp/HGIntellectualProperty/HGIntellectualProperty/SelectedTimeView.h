//
//  SelectedTimeView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedTimeView : UIView

-(instancetype)initWithParentView:(UIView *)parentView;
-(void)show;
-(void)hidden;
@property(nonatomic,copy)void(^selectedTimeBlock)(NSString *time);

@end
