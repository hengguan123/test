//
//  AgentDomainModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/21.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AgentDomainModel.h"

@implementation AgentDomainModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"classifyCode":@"classifyCode",
                @"delFlag":@"delFlag",
                @"facilitatorId":@"facilitatorId",
                @"modelId":@"id",
                @"price":@"price",
                @"classifyName":@"classifyName",
             };
}

@end
