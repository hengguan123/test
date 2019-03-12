//
//  AccountSetTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/1/31.
//  Copyright © 2018年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AccountSetTableViewCell;
@protocol AccountSetTableViewCellDelegate <NSObject>

-(void)btnClickAccountSetTableViewCell:(AccountSetTableViewCell *)cell;

@end


@interface AccountSetTableViewCell : UITableViewCell

@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)BOOL sel;
@property(nonatomic,weak)id<AccountSetTableViewCellDelegate >delegate;

@end
