//
//  PatentTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/14.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PatentTableViewCell : UITableViewCell

@property(nonatomic,strong)PatentModel *model;

@property(nonatomic,strong)MonitorContentModel *moniModel;

@property(nonatomic,copy)NSString *searchStr;



@end
