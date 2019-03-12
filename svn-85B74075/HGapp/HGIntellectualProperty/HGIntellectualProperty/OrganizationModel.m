//
//  OrganizationModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/17.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "OrganizationModel.h"

@implementation OrganizationModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"departName":@"departName",
                @"listAddr":@"listAddr",
                @"departCode":@"departCode",
                @"dictionaryName":@"dictionaryName",
                @"dictionaryCode":@"dictionaryCode",
                @"addrCode":@"addrCode",
                @"addrName":@"addrName",
             };
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"listAddr"]) {
        _listAddr = [MTLJSONAdapter modelsOfClass:[OrgAreaModel class] fromJSONArray:value error:nil];
    }
}


@end
