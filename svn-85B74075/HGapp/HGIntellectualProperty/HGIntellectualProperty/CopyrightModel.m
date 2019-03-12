//
//  CopyrightModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/21.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CopyrightModel.h"

@implementation CopyrightModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"registerNum":@"registerNum",
                @"classType":@"classType",
                @"copyrightName":@"copyName",
                @"shortName":@"shortName",
                @"createDate":@"createDate",
                @"version":@"version",
                @"owner":@"owner",
                @"publishDate":@"publishDate",
                @"registerDate":@"registerDate",
                @"type":@"copyType",
                @"createTime":@"createTime",
             };
}


@end
