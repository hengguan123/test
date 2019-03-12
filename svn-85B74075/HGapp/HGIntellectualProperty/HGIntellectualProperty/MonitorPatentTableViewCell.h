//
//  MonitorPatentTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MonitorPatentTableViewCell;

@protocol MonitorPatentTableViewCellDelegate <NSObject>

- (void)clickBtnMonitorPatentTableViewCell:(MonitorPatentTableViewCell *)cell;

@end

@interface MonitorPatentTableViewCell : UITableViewCell

@property(nonatomic,strong)MonitorContentModel *moniModel;
@property(nonatomic,weak)id<MonitorPatentTableViewCellDelegate>delegate;

@end
