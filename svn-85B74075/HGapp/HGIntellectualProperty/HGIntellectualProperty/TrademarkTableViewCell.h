//
//  TrademarkTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrademarkTableViewCell : UITableViewCell

@property(nonatomic,strong)TrademarkModel *model;
@property(nonatomic,strong)MonitorContentModel *moniModel;
@property(nonatomic,assign)BOOL hiddenTag;
@property(nonatomic,copy)NSString *searchStr;

@end
