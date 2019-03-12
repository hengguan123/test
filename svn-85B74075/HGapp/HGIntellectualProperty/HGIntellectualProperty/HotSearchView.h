//
//  HotSearchView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HotSearchViewType) {
    HotSearchViewTypeAll=1,
    /// 专利
    HotSearchViewTypePatent=2,
    /// 商标
    HotSearchViewTypeTrademark=3,
    /// 版权
    HotSearchViewTypePatentScore=4,
    /// 产权分析
    HotSearchViewTypeProperty=5,
    
};


@protocol HotSearchViewDelegate <NSObject>

-(void)didSelectedKeyWord:(NSString *)keyword;
-(void)duringScrolling;

@end

@interface HotSearchView : UITableView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)id<HotSearchViewDelegate>actionDelegate;

-(void)defaultConfigType:(HotSearchViewType )type;
-(void)reloadDataWithType:(int)type;
@end
