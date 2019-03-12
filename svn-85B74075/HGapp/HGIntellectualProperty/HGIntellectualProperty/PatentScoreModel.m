//
//  PatentScoreModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PatentScoreModel.h"

@implementation PatentScoreModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"num":@"num",
                @"score":@"score",
                @"texts":@"texts",
                @"title":@"title",
             };
}

@end
