//
//  TrademarkModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface TrademarkModel : MTLModel<MTLJSONSerializing>
/// 类
@property(nonatomic,copy)NSString *intCls;
/// 名称
@property(nonatomic,copy)NSString *tmName;
/// 状态
@property(nonatomic,copy)NSString *currentStatus;
/// 图
@property(nonatomic,copy)NSString *tmImg;
/// 申请日期
@property(nonatomic,copy)NSString *appDate;
/// 注册日期
@property(nonatomic,copy)NSString *regDate;
/// 注册号
@property(nonatomic,copy)NSString *regNo;
/// 申请公司
@property(nonatomic,copy)NSString *applicantCn;

@end
