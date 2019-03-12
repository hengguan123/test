//
//  BannerModel.m
//  Star
//
//  Created by GJ on 16/1/19.
//  Copyright © 2016年 GJ. All rights reserved.
//

#import "BannerModel.h"

@implementation BannerModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"sid":@"id",
             @"skipType":@"useWebsiteCode",
             @"url":@"imgUrl",
             @"skipLink":@"skipLink",
             @"title":@"imgDesc",
            };
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"url"]) {
        if ([value hasPrefix:@"http://"]) {
            _url = value;
        }
        else
        {
            _url = ImageURL(value);
        }
    }
}
@end
