//
//  MyGrapTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ErrandTableViewCellType) {
    ErrandTableViewCellTypeMyGrap,
    ErrandTableViewCellTypeToCommented,
    ErrandTableViewCellStyleToPay,
};

@class MyGrapTableViewCell;
@protocol MyGrapTableViewCellDelegate <NSObject>

-(void)writeReviewTableViewCell:(MyGrapTableViewCell *)cell;
-(void)addProgressTableViewCell:(MyGrapTableViewCell *)cell;
-(void)lookProgressTableViewCell:(MyGrapTableViewCell *)cell;
-(void)payTableViewCell:(MyGrapTableViewCell *)cell;

@end

@interface MyGrapTableViewCell : UITableViewCell


@property(nonatomic,assign)ErrandTableViewCellType type;
@property(nonatomic,weak)id<MyGrapTableViewCellDelegate>delegate;
@property(nonatomic,strong)ErrandModel *model;


@end
