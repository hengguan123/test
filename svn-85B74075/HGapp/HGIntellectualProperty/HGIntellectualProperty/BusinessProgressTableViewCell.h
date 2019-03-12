//
//  BusinessProgressTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/5/9.
//  Copyright © 2018年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BusinessProgressType) {
    BusinessProgressTypeCurrent,
    BusinessProgressTypeDefault,
    BusinessProgressTypeFirst,
    BusinessProgressTypeFirstAndCurrent
};
@interface BusinessProgressTableViewCell : UITableViewCell

@property(nonatomic,strong)CRMOrderProcessModel *model;
@property(nonatomic,assign)BusinessProgressType type;

@end
