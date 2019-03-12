//
//  ErrandModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ErrandModel.h"

@implementation ErrandModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"errandId":@"errandId",
                @"updateTime":@"updateTime",
                @"errandTitle":@"errandTitle",
                @"isRobOrder":@"isRobOrder",
                @"usrName":@"usrName",
                @"usrId":@"usrId",
                @"createTime":@"createTime",
                @"price":@"price",
                @"fileUrl":@"fileUrl",
                @"remark":@"remark",
                @"busiTypeName":@"busiTypeName",
                @"dwellAddrName":@"dwellAddrName",
                @"domainName":@"domainName",
                @"errandTypeName":@"errandTypeName",
                @"time":@"time",
                @"dwellAddr":@"dwellAddr",
                @"busiType":@"busiType",
                @"errandType":@"errandType",
                @"classifyDomain":@"classifyDomain",
                
                @"replyContent":@"replyContent",
                @"errandStatusName":@"errandStatusName",
                @"isReply":@"isReply",
                @"provinceName":@"provinceName",
                @"robTime":@"robTime",
                @"robId":@"robId",
                @"errandStatus":@"errandStatus",
                @"faciId":@"faciId",
                
                @"orderId":@"orderId",
                @"orderNo":@"orderNo",
                @"superOrderNo":@"superOrderNo",
                @"faciName":@"faciName",
                @"phone":@"reseFiel1",
                @"faciPhone":@"mobilePhone",
                @"isInside":@"reseFiel2",
             };
}
@end
