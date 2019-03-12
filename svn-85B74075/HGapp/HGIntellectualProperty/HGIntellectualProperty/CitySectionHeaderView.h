//
//  CitySectionHeaderView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CitySectionHeaderView;
@protocol CitySectionHeaderViewDelegate <NSObject>

- (void)openOrCloseCitySectionHeaderView:(CitySectionHeaderView *)citySectionHeaderView;

@end


@interface CitySectionHeaderView : UIView

@property(nonatomic,weak)id<CitySectionHeaderViewDelegate>delegate;
@property(nonatomic,assign,getter=isOpen)BOOL open;
@property(nonatomic,assign)NSInteger sention;
@property(nonatomic,copy)NSString *provinceName;

@end
