//
//  AssociateView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/24.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AssociateView;
@protocol AssociateViewDelegate <NSObject>

-(void)associateView:(AssociateView *)view didSelectedKeyStr:(NSString *)keyStr;
-(void)associateView:(AssociateView *)view didSelectedCompanyName:(NSString *)companyName;
-(void)duringScrolling;

@end

@interface AssociateView : UIView

-(instancetype)initWithFrame:(CGRect)frame type:(NSInteger)type presentView:(UIView *)view;

-(void)searchStrChange:(NSString *)str;
@property(nonatomic,weak)id<AssociateViewDelegate>delegate;
@property(nonatomic,assign)BOOL isSell;
@property(nonatomic,strong)NSArray *hotArray;
@property(nonatomic,assign,getter=isHotSearch)BOOL hotSearch;






@end
