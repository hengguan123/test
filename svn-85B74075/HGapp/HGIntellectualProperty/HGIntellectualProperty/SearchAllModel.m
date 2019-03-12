//
//  SearchAllModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SearchAllModel.h"

@implementation SearchAllModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"companyName":@"AN",
                @"patentNum":@"patentNum",
                @"tradeNum":@"tradeNum",
                @"copyrightNum":@"copyNum",
                @"address":@"AN_ADD",
                
             };
}

@end
