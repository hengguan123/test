//
//  AgentTypeModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/21.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AgentTypeModel.h"

@implementation AgentTypeModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"auditStatus":@"auditStatus",
                @"delFlag":@"delFlag",
                @"facilitatorId":@"facilitatorId",
                @"price":@"price",
                @"rangeId":@"rangeId",
                @"saleNum":@"saleNum",
                @"serviceType":@"serviceType",
                @"serviceTypeName":@"serviceTypeName",
                @"starService":@"starService",
                @"starServiceName":@"starServiceName",
                @"typeInfo":@"typeInfo",
                @"cost":@"cost",
                @"starPrice":@"starPrice",
             };
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"typeInfo"]) {
        _typeInfo = [MTLJSONAdapter modelsOfClass:[AgentSutTypeModel class] fromJSONArray:value error:nil];
    }
}

@end
