//
//  VersionModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "VersionModel.h"

@implementation VersionModel


+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"name":@"name",
                @"versionNo":@"versionNo",
                @"coerceStatus":@"coerceStatus",
                @"versionDesc":@"versionDesc",
                @"versionInfo":@"versionInfo",
             };
}


@end
