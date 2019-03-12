//
//  WorksCopyrightModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "WorksCopyrightModel.h"

@implementation WorksCopyrightModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"number":@"number",
                @"name":@"name",
                @"category":@"category",
                @"author":@"author",
                @"owner":@"owner",
                @"date":@"date",
             };
}


@end
