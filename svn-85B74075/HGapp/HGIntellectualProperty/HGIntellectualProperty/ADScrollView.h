//
//  ADScrollView.h
//  Star
//
//  Created by GJ on 16/3/23.
//  Copyright © 2016年 GJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BannerModel.h"
@class ADScrollView;
@protocol ADScrollViewDelegate <NSObject>

-(void)adScrollView:(ADScrollView *)adScrollView didSelectedBannerWith:(BannerModel *)bannerModel;

@end

@interface ADScrollView : UIView <UIScrollViewDelegate>

@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,weak)id<ADScrollViewDelegate>delegate;

@end
