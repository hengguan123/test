//
//  TrademarkModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "TrademarkModel.h"

@implementation TrademarkModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"intCls":@"intCls",
                @"tmName":@"tmName",
                @"currentStatus":@"currentStatus",
                @"tmImg":@"tmImg",
                @"appDate":@"appDate",
                @"regDate":@"regDate",
                @"regNo":@"regNo",
                @"applicantCn":@"applicantCn",
             };
}


@end
