//
//  SystemMessageModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SystemMessageModel.h"

@implementation SystemMessageModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"createTime":@"createTime",
                @"msgContent":@"msgContent",
                @"msgId":@"msgId",
                @"msgTitle":@"msgTitle",
                @"msgType":@"msgType",
                @"msgTypeName":@"msgTypeName",
                @"readStatus":@"readStatus",
                @"usrId":@"usrId",
             };
}
@end
