//
//  AgentTypeModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/21.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface AgentTypeModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *serviceTypeName;
@property(nonatomic,copy)NSString *delFlag;
@property(nonatomic,copy)NSString *starServiceName;
@property(nonatomic,strong)NSArray *typeInfo;
@property(nonatomic,strong)NSNumber *price;
@property(nonatomic,copy)NSString *serviceType;
@property(nonatomic,strong)NSNumber *saleNum;
@property(nonatomic,strong)NSNumber *facilitatorId;
@property(nonatomic,copy)NSString *starService;
@property(nonatomic,copy)NSString *auditStatus;
@property(nonatomic,strong)NSNumber *rangeId;
@property(nonatomic,strong)NSNumber *starPrice;
@property(nonatomic,strong)NSNumber *cost;
//@property(nonatomic,strong)NSNumber *rangeId;



@end
