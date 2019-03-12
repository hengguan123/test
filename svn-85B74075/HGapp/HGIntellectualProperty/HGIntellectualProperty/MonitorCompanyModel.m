//
//  MonitorCompanyModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MonitorCompanyModel.h"

@implementation MonitorCompanyModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"address":@"address",
                @"companyName":@"companyName",
                @"isLook":@"isLook",
                @"monitorId":@"monitorId",
                @"monitorStatus":@"monitorStatus",
                @"remark":@"remark",
                @"usrId":@"usrId",
             };
}

@end
