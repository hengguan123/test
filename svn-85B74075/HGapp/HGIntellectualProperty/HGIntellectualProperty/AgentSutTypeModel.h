//
//  AgentSutTypeModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/21.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface AgentSutTypeModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *detailTypeName;
@property(nonatomic,copy)NSString *delFlag;
@property(nonatomic,strong)NSNumber *modelId;
@property(nonatomic,strong)NSNumber *price;
@property(nonatomic,strong)NSNumber *facilitatorId;
@property(nonatomic,copy)NSString *detailType;
@property(nonatomic,strong)NSNumber *rangeId;
@property(nonatomic,strong)NSNumber *cost;


@end
