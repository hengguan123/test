//
//  ErrandClassModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ErrandClassModel.h"

@implementation ErrandClassModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"addUsrId":@"addUsrId",
                @"createTime":@"createTime",
                @"dictionaryCode":@"dictionaryCode",
                @"dictionaryId":@"dictionaryId",
                @"dictionaryName":@"dictionaryName",
                @"dictionaryStatus":@"dictionaryStatus",
                @"fileNum":@"fileNum",
                @"fileRemark":@"fileRemark",
                @"isNode":@"isNode",
                @"superDictionaryCode":@"superDictionaryCode",
                @"updateTime":@"updateTime",
                @"updateUsrId":@"updateUsrId",
                @"delFlag":@"delFlag",
                @"rangeId":@"rangeId",
                @"listSerTypeInfo":@"listSerTypeInfo",
                @"starService":@"starService",
                @"price":@"price",
                @"modelId":@"id",
                @"remark":@"remark",
                @"auditStatus":@"auditStatus"
             };
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"listSerTypeInfo"]) {
        _listSerTypeInfo = [MTLJSONAdapter modelsOfClass:[ErrandClassModel class] fromJSONArray:value error:nil];
    }

}


@end
