//
//  RingProgressView.h
//  Demo
//
//  Created by 耿广杰 on 2017/8/18.
//  Copyright © 2017年 GG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PatentScoreModel.h"

@interface RingProgressView : UIView

-(void)setProgress:(CGFloat )progress;
/// 进度环颜色
@property(nonatomic,strong)UIColor *ringColor;
/// 背景环颜色
@property(nonatomic,strong)UIColor *foregroundColor;

@property(nonatomic,strong)PatentScoreModel *model;

@end
