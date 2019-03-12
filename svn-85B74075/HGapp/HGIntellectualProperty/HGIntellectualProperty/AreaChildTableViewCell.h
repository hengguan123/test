//
//  AreaChildTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AreaChildTableViewCell;
@protocol AreaChildTableViewCellDelegate <NSObject>

-(void)areaChildTableViewCell:(AreaChildTableViewCell *)cell didSelAreaItemWithModel:(AreaModel *)model;

@end

@interface AreaChildTableViewCell : UITableViewCell

@property(nonatomic,strong)AreaModel *provinceModel;
@property(nonatomic,weak)id<AreaChildTableViewCellDelegate>delegate;


@end
