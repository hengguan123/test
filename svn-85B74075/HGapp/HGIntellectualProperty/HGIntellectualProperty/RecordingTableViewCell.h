//
//  RecordingTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RecordingTableViewCellType) {
    RecordingTableViewCellTypeIncome,
    RecordingTableViewCellTypeCash,
    RecordingTableViewCellTypepay,
};



@interface RecordingTableViewCell : UITableViewCell

@property(nonatomic,strong)RecordingModel *model;

@end
