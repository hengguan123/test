//
//  MonitorContentModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/10.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MonitorContentModel.h"

@implementation MonitorContentModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"busiType":@"busiType",
                @"title":@"title",
                @"monitorType":@"monitorType",
                @"pn":@"pn",
                @"pbd":@"pbd",
                @"nwLegal":@"newLegal",
                @"oldLegal":@"oldLegal",
                @"remark":@"remark",
                @"isLook":@"isLook",
                @"uniquelyid":@"dataId",
                @"imgUrl":@"imgUrl",
                @"monitorId":@"monitorId",
                @"ipc":@"ipc",
                @"dbName":@"dbName",
                @"companyName":@"companyName",
                @"monitorStatus":@"monitorStatus",
                @"modelId":@"id",
             };
}

@end
