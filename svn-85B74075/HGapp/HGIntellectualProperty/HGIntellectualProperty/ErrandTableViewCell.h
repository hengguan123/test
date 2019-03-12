//
//  ErrandTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/1.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ErrandTableViewCellStyle) {
    ErrandTableViewCellStyleDefault,
    ErrandTableViewCellStyleImage,
};
@class ErrandTableViewCell;
@protocol ErrandTableViewCellDelegate <NSObject>

- (void)grabOrderWithErrandTableViewCell:(ErrandTableViewCell *)errandTableViewCell sender:(UIButton *)sender;

@end

@interface ErrandTableViewCell : UITableViewCell

@property(nonatomic,weak)id<ErrandTableViewCellDelegate>delegate;
@property(nonatomic,strong)ErrandModel *model;

@end
