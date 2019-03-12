//
//  MyPublishTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyPublishTableViewCell;
@protocol MyPublishTableViewCellDelegate <NSObject>

-(void)deleteErrandMyPublishTableViewCell:(MyPublishTableViewCell *)cell;
-(void)changeErrandMyPublishTableViewCell:(MyPublishTableViewCell *)cell;
-(void)lookoverProgressPublishTableViewCell:(MyPublishTableViewCell *)cell;


@end

@interface MyPublishTableViewCell : UITableViewCell

@property(nonatomic,strong)ErrandModel *model;
@property(nonatomic,weak)id<MyPublishTableViewCellDelegate>delegate;


@end
