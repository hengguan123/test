//
//  BusinessModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BusinessModel : MTLModel<MTLJSONSerializing>

/// 显示对勾标志
@property(nonatomic,copy)NSString *delFlag;
/// 业务名称
@property(nonatomic,copy)NSString *dictionaryName;
/// 设定价格
@property(nonatomic,strong)NSNumber *price;
/// code码
@property(nonatomic,copy)NSString *dictionaryCode;
/// 父code码
@property(nonatomic,copy)NSString *superDictionaryCode;
/// 审核状态 --- 显示与否
@property(nonatomic,copy)NSString *auditStatus;
/// 备注
@property(nonatomic,copy)NSString *remark;
/// 二级列表
@property(nonatomic,strong)NSArray *listChildDict;
/// 三级列表
@property(nonatomic,strong)NSArray *listChild;
/// 星级列表
@property(nonatomic,strong)NSArray *listStar;
/// 星级
@property(nonatomic,copy)NSString *starService;
/// 星星亮
@property(nonatomic,copy)NSString *isSel;



@end
