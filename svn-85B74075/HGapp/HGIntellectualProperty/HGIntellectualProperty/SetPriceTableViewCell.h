//
//  SetPriceTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/29.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SetPriceTableViewCell;
@protocol SetPriceTableViewCellDelegate <NSObject>

-(void)priceChangeWithSetPriceTableViewCell:(SetPriceTableViewCell *)cell;

@end

@interface SetPriceTableViewCell : UITableViewCell

@property(nonatomic,weak)id<SetPriceTableViewCellDelegate>delegate;
@property(nonatomic,strong)BusinessModel *busiModel;

@end
