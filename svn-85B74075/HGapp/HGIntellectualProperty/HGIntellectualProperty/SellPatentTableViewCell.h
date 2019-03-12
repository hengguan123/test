//
//  SellPatentTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/28.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SellPatentTableViewCell;
@protocol SellPatentTableViewCellDelegate <NSObject>

-(void)deletePatentModelWithCell:(SellPatentTableViewCell *)cell;

@end

@interface SellPatentTableViewCell : UITableViewCell

@property(nonatomic,strong)PatentModel *sellPatentModel;
@property(nonatomic,weak)id<SellPatentTableViewCellDelegate>delegate;


@end
