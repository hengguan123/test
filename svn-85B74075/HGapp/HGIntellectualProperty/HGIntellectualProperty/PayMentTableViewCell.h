//
//  PayMentTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/14.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PayMentTableViewCell;
@protocol PayMentTableViewCellDelegate <NSObject>

-(void)payWithPayMentTableViewCell:(PayMentTableViewCell *)cell;

@end

@interface PayMentTableViewCell : UITableViewCell

@property(nonatomic,strong)OrderModel *model;
@property(nonatomic,weak)id<PayMentTableViewCellDelegate>delegate;

@property(nonatomic,assign)BOOL payHidden;


@end
