//
//  AgentSutTypeModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/21.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AgentSutTypeModel.h"

@implementation AgentSutTypeModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"delFlag":@"delFlag",
                @"detailType":@"detailType",
                @"detailTypeName":@"detailTypeName",
                @"facilitatorId":@"facilitatorId",
                @"modelId":@"id",
                @"price":@"price",
                @"rangeId":@"rangeId",
                @"cost":@"cost",
             };
}

@end
