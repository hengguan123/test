//
//  ShoppingTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/17.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShoppingTableViewCell;
@protocol ShoppingTableViewCellDelegate <NSObject>

-(void)tapSelBtnShoppingTableViewCell:(ShoppingTableViewCell *)cell;

@end

@interface ShoppingTableViewCell : UITableViewCell

@property(nonatomic,strong)NoPayModel *model;
@property(nonatomic,weak)id<ShoppingTableViewCellDelegate>delegate;

@end
