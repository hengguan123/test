//
//  ChildOrderModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ChildOrderModel.h"

@implementation ChildOrderModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"busId":@"busId",
                @"createTime":@"createTime",
                @"goodsImg":@"goodsImg",
                @"goodsName":@"goodsName",
                @"goodsPrice":@"goodsPrice",
                @"orderInfoId":@"orderInfoId",
                @"orderNo":@"orderNo",
                @"orderStatus":@"orderStatus",
                @"superOrderNo":@"superOrderNo",
                @"updateTime":@"updateTime",
                @"busiQuality":@"busiQuality",
                @"businessId":@"businessId",
                @"businessType":@"businessType",
                @"type":@"type",
             };
}


@end
