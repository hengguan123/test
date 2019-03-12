//
//  CompanyEnableProgressPatentModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/11.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CompanyEnableProgressPatentModel.h"

@implementation CompanyEnableProgressPatentModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"patentName":@"patentName",
                @"caseType":@"caseType",
                @"applyDate":@"applyDate",
                @"applyPerson":@"applyPerson",
                @"applyNo":@"applyNo",
                @"caseStatus":@"caseStatus",
                @"insetUrl":@"insetUrl",
                @"caseUuid":@"caseUuid",
                @"compUuid":@"compUuid"
             };
}



@end
