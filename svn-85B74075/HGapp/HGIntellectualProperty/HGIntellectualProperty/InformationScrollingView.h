//
//  InformationScrollingView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/24.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InformationScrollingViewDelegate <NSObject>

-(void)taptap;

@end

@interface InformationScrollingView : UIView<UIScrollViewDelegate>

@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,weak)id<InformationScrollingViewDelegate>delegate;

@end
