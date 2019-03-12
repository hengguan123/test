//
//  CopyrightHotView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CopyrightHotViewDelegate <NSObject>

-(void)didSelectedHotStr:(NSString *)hotStr;

@end

@interface CopyrightHotView : UIView

@property(nonatomic,weak)id<CopyrightHotViewDelegate>delegate;
-(instancetype)initWithFrame:(CGRect)frame;

-(void)loadDataWithType:(NSString *)type;

@end
