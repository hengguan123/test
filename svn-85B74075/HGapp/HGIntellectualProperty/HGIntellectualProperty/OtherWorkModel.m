//
//  OtherWorkModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/9.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "OtherWorkModel.h"

@implementation OtherWorkModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"dictionaryName":@"dictionaryName",
             @"dictionaryCode":@"dictionaryCode",
             @"superDictionaryCode":@"superDictionaryCode",
             @"listChildDict":@"listChildDict",
             @"listChild":@"listChild",
             @"listData":@"listData",
             @"listOther":@"listOther",
             };
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"listChildDict"]) {
        _listChildDict = [MTLJSONAdapter modelsOfClass:[OtherWorkModel class] fromJSONArray:value error:nil];
    }
    else if ([key isEqualToString:@"listChild"])
    {
        NSMutableArray *array = [NSMutableArray new];
        [array addObjectsFromArray: [MTLJSONAdapter modelsOfClass:[OtherWorkModel class] fromJSONArray:value error:nil]];
        for (OtherWorkModel *model in array) {
            if ([model.dictionaryName isEqualToString:@"OA答复"]) {
                [array removeObject:model];
            }
        }
        _listChild = array;
    }
    else if ([key isEqualToString:@"listData"]) {
        _listData = [MTLJSONAdapter modelsOfClass:[OtherWorkModel class] fromJSONArray:value error:nil];
    }
    else if ([key isEqualToString:@"listOther"])
    {
        _listOther = [MTLJSONAdapter modelsOfClass:[OtherWorkModel class] fromJSONArray:value error:nil];
    }
}


@end
