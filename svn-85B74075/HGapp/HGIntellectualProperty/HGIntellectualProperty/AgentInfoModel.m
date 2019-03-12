//
//  AgentInfoModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AgentInfoModel.h"

@implementation AgentInfoModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"facilitatorName":@"facilitatorName",
             @"portraitUrl":@"portraitUrl",
             @"facilitatorId":@"facilitatorId",
             @"credUrl":@"credUrl",
             @"dwellAddr":@"dwellAddr",
             @"mobilePhone":@"mobilePhone",
             @"qq":@"qq",
             @"fileUrl1":@"fileUrl1",
             @"fileUrl2":@"fileUrl2",
             @"bankCardNo":@"bankCardNo",
             @"bankOpen":@"bankOpen",
             @"bankLocale":@"bankLocale",
             @"serveManifesto":@"serveManifesto",
             @"serveBrief":@"serveBrief",
             @"ortherInfo":@"ortherInfo",
             @"realName":@"realName",
             @"annualStatus":@"annualStatus",
             @"practCertNo":@"practCertNo",
             @"qualCertNo":@"qualCertNo",
             @"companyName":@"companyName",
             @"organNo":@"organNo",
             @"email":@"email",
             };
}


@end
