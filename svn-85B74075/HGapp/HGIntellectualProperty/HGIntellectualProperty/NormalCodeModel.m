//
//  NormalCodeModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "NormalCodeModel.h"

@implementation NormalCodeModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"name":@"name",
                @"code":@"code",
             };
}

@end
