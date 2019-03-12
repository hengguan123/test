//
//  SearchCompanyTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchCompanyTableViewCell;
@protocol SearchCompanyTableViewCellDelegare <NSObject>

-(void)patentListWithSearchCompanyTableViewCell:(SearchCompanyTableViewCell *)cell;
-(void)trademarkListWithSearchCompanyTableViewCell:(SearchCompanyTableViewCell *)cell;
-(void)copyrightListWithSearchCompanyTableViewCell:(SearchCompanyTableViewCell *)cell;


@end


@interface SearchCompanyTableViewCell : UITableViewCell

@property(nonatomic,strong)SearchAllModel *model;
@property(nonatomic,weak)id<SearchCompanyTableViewCellDelegare>delegate;


@end
