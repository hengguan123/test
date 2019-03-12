//
//  RecordingModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "RecordingModel.h"

@implementation RecordingModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"createTime":@"createTime",
                @"bankOpen":@"bankOpen",
                @"bankLocale":@"bankLocale",
                @"bankCardNo":@"bankCardNo",
                @"optStatus":@"optStatus",
                @"usrRealName":@"usrRealName",
                @"usrId":@"usrId",
                @"optType":@"optType",
                @"optMoney":@"optMoney",
                @"optDesc":@"optDesc",
                @"modelId":@"id",
                @"week":@"dateWeek"
             };
}


@end
