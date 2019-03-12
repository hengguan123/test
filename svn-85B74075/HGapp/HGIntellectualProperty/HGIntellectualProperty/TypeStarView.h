//
//  TypeStarView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TypeStarView : UIView


@property(nonatomic,strong)ErrandClassModel *model;
-(instancetype)initWithFrame:(CGRect)frame;
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,assign)BOOL tap;
@property(nonatomic,assign)NSInteger index;


@end
