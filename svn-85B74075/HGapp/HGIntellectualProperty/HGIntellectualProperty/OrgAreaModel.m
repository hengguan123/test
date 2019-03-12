//
//  OrgAreaModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/17.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "OrgAreaModel.h"

@implementation OrgAreaModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"addrName":@"addrName",
                @"listAddr":@"listAddr",
                @"listDept":@"listDept",
                @"addrCode":@"addrCode",
             };
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"listDept"]) {
        _listDept = [MTLJSONAdapter modelsOfClass:[OrganizationModel class] fromJSONArray:value error:nil];
    }
    else if ([key isEqualToString:@"listAddr"])
    {
        NSArray *array = value;
        NSArray *cityCodeArray = @[@"CHN110100",@"CHN120100",@"CHN310100",@"CHN500100"];
        NSString *cityCode = [array.firstObject objectForKey:@"addrCode"];
        if ([cityCodeArray containsObject:cityCode] ) {
            NSArray *list = [array.firstObject objectForKey:@"listAddr"];
            _listAddr = [MTLJSONAdapter modelsOfClass:[OrgAreaModel class] fromJSONArray:list error:nil];
        }
        else
        {
            _listAddr = [MTLJSONAdapter modelsOfClass:[OrgAreaModel class] fromJSONArray:value error:nil];
        }
    }
}


@end
