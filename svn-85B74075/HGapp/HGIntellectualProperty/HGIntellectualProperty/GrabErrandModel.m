//
//  GrabErrandModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "GrabErrandModel.h"

@implementation GrabErrandModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"errandId":@"errandId",
                @"replyContent":@"replyContent",
                @"remark":@"remark",
                @"errandStatusName":@"errandStatusName",
                @"busiTypeName":@"busiTypeName",
                @"dwellAddrName":@"dwellAddrName",
                @"domainName":@"domainName",
                @"createTime":@"createTime",
                @"isReply":@"isReply",
                @"usrName":@"usrName",
                @"provinceName":@"provinceName",
                @"price":@"price",
                @"errandTitle":@"errandTitle",
                @"errandTypeName":@"errandTypeName",
            };
}

@end
