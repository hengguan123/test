//
//  PatentProgressModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/31.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PatentProgressModel.h"

@implementation PatentProgressModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"agentPerson":@"agentPerson",
                @"applyDate":@"applyDate",
                @"applyNo":@"applyNo",
                @"applyPerson":@"applyPerson",
                @"caseClientName":@"caseClientName",
                @"caseNo":@"caseNo",
                @"caseProc":@"caseProc",
                @"caseSourcePerson":@"caseSourcePerson",
                @"caseStatus":@"caseStatus",
                @"clientCode":@"clientCode",
                @"clientNo":@"clientNo",
                @"createDate":@"createDate",
                @"disposePerson":@"disposePerson",
                @"eleParts":@"eleParts",
                @"examinant":@"examinant",
                @"fetchDate":@"fetchDate",
                @"fetchPerson":@"fetchPerson",
                @"fileName":@"fileName",
                @"forwardDate":@"forwardDate",
                @"forwardStatus":@"forwardStatus",
                @"modelId":@"id",
                @"inventPerson":@"inventPerson",
                @"isOfficial":@"isOfficial",
                @"officeDispatchNo":@"officeDispatchNo",
                @"patentName":@"patentName",
                @"pd":@"pd",
                @"pn":@"pn",
                @"pubDate":@"pubDate",
                @"receOrgAgency":@"receOrgAgency",
                @"receOrgOff":@"receOrgOff",
                @"receiveDate":@"receiveDate",
                @"receivedClient":@"receivedClient",
                @"receivedType":@"receivedType",
                @"receivedWay":@"receivedWay",
                @"registrant":@"registrant",
                @"updateDate":@"updateDate",
                
             };
}

@end
