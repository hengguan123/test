//
//  SetPriceView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TypeStarView.h"
@interface SetPriceView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

@property(nonatomic,strong)ErrandClassModel *model;
@property(nonatomic,strong)ErrandClassModel *supperModel;
@property(nonatomic,assign)NSInteger type;//2具体业务  3领域
@property(nonatomic,strong)TypeStarView *fatherView;

@end
