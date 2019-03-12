//
//  FilterTypeModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/23.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "FilterTypeModel.h"

@implementation FilterTypeModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    // value should be Class or Class name.
    return @{
             @"childArray" : [FilterTypeModel class],
             };
}

@end
