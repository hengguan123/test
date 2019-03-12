//
//  AreaModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/6.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AreaModel.h"

@implementation AreaModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"addrCode":@"addrCode",
             @"updateUsrId":@"updateUsrId",
             @"addrPost":@"addrPost",
             @"createTime":@"createTime",
             @"addUsrId":@"addUsrId",
             @"addrId":@"addrId",
             @"addrLevel":@"addrLevel",
             @"updateTime":@"updateTime",
             @"addrName":@"addrName",
             @"superAddrCode":@"superAddrCode",
             @"addrStatus":@"addrStatus",
             @"subAddsArray":@"subAddsArray",
             };
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"subAddsArray"]) {
        _subAddsArray = [MTLJSONAdapter modelsOfClass:[AreaModel class] fromJSONArray:value error:nil];
    }
}

@end
