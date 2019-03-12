//
//  BusinessModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "BusinessModel.h"

@implementation BusinessModel


+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"delFlag":@"delFlag",
                @"dictionaryName":@"dictionaryName",
                @"price":@"price",
                @"dictionaryCode":@"dictionaryCode",
                @"superDictionaryCode":@"superDictionaryCode",
                @"auditStatus":@"auditStatus",
                @"remark":@"remark",
                @"listChildDict":@"listChildDict",
                @"listChild":@"listChild",
                @"listStar":@"listStar",
                @"starService":@"starService",
                @"isSel":@"isSel",
             };
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"listChildDict"]) {
        _listChildDict = [MTLJSONAdapter modelsOfClass:[BusinessModel class] fromJSONArray:value error:nil];
    }
    else if ([key isEqualToString:@"listChild"])
    {
        _listChild = [MTLJSONAdapter modelsOfClass:[BusinessModel class] fromJSONArray:value error:nil];
    }
    else if ([key isEqualToString:@"listStar"])
    {
        _listStar = [MTLJSONAdapter modelsOfClass:[BusinessModel class] fromJSONArray:value error:nil];
    }
}

@end
