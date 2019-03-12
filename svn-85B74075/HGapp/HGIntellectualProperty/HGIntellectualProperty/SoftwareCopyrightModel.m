//
//  SoftwareCopyrightModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SoftwareCopyrightModel.h"

@implementation SoftwareCopyrightModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"number":@"number",
                @"category":@"category",
                @"name":@"name",
                @"owner":@"owner",
                @"nationality":@"nationality",
                @"recordDate":@"recordDate",
                @"postDate":@"postDate",
                
             };
}

@end
