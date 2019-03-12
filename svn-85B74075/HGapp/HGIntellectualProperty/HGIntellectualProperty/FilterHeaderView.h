//
//  FilterHeaderView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FilterHeaderViewDelegate <NSObject>

-(void)reloadHeaderView;

-(void)selectedDomianWithArray:(NSArray *)array;
-(void)selectedTypeWithArray:(NSArray *)array;
-(void)selectedSubtypeWithArray:(NSArray *)array;



@end


@interface FilterHeaderView : UIView

+ (instancetype)share;

@property(nonatomic,weak)id<FilterHeaderViewDelegate>delegate;

-(void)reSet;


@end
