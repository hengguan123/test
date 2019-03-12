//
//  NoPayModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/14.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "NoPayModel.h"

@implementation NoPayModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"busId":@"busId",
                @"busiQuality":@"busiQuality",
                @"businessType":@"businessType",
                @"businessTypeName":@"businessTypeName",
                @"classifyName":@"classifyName",
                @"createTime":@"createTime",
                @"faciId":@"faciId",
                @"fileNum":@"fileNum",
                @"goodsId":@"goodsId",
                @"goodsImg":@"goodsImg",
                @"goodsName":@"goodsName",
                @"goodsType":@"goodsType",
                @"modelId":@"id",
                @"price":@"price",
                @"type":@"type",
             };
}

+(NSArray *)arrarWithArray:(NSArray *)array
{
    NSMutableArray *muArr = [NSMutableArray new];
    for (NSDictionary *dict in array) {
        NoPayModel *model = [NoPayModel new];
        [model setValuesForKeysWithDictionary:dict];
        [muArr addObject:model];
    }
    return muArr;
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
}

@end
