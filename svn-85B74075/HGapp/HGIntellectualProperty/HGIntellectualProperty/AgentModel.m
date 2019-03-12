//
//  AgentModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AgentModel.h"

@implementation AgentModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"provinceName":@"provinceName",
                @"starName":@"starName",
                @"starService":@"starService",
                @"usrId":@"usrId",
                @"mobilePhone":@"mobilePhone",
                @"city":@"city",
                @"facilitatorId":@"facilitatorId",
                @"facilitatorName":@"facilitatorName",
                @"serveBrief":@"serveBrief",
                @"serveManifesto":@"serveManifesto",
                @"queryListClassify":@"queryListClassify",
                @"queryListRange":@"queryListRange",
                @"cityName":@"cityName",
                @"portraitUrl":@"portraitUrl",
                @"unitPrice":@"unitPrice",
             };
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"queryListRange"]) {
        _queryListRange = [MTLJSONAdapter modelsOfClass:[AgentTypeModel class] fromJSONArray:value error:nil];
    }
    else if ([key isEqualToString:@"queryListClassify"])
    {
        _queryListClassify = [MTLJSONAdapter modelsOfClass:[AgentDomainModel class] fromJSONArray:value error:nil];
    }
}

@end
