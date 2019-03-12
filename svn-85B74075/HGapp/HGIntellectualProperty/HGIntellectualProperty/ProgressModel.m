//
//  ProgressModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ProgressModel.h"

@implementation ProgressModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"addAccounts":@"addAccounts",
                @"createTime":@"createTime",
                @"endTime":@"endTime",
                @"errandId":@"errandId",
                @"errandStatus":@"errandStatus",
                @"errandStatusName":@"errandStatusName",
                @"modelId":@"id",
                @"remark":@"remark",
                @"replyContent":@"replyContent",
             };
}

@end
