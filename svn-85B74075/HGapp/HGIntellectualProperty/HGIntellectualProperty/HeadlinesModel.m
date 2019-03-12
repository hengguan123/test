//
//  HeadlinesModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HeadlinesModel.h"

@implementation HeadlinesModel

+(NSDictionary *)modelCustomPropertyMapper
{
    return @{
                @"articleId":@"id",
            };
}
+ (NSArray *)modelPropertyBlacklist {
    return @[@"sourceUrl"];
}
@end
