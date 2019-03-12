//
//  PatentModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/14.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PatentModel.h"

@implementation PatentModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
//                @"ABST":@"ABST",
                @"AN":@"AN",
//                @"AN_ADD":@"AN_ADD",
                @"APD":@"APD",
                @"APN":@"APN",
//                @"DATASET":@"DATASET",
                @"GIF_URL":@"GIF_URL",
                @"ID":@"ID",
                @"IN":@"IN",
//                @"IPC":@"IPC",
                @"PBD":@"PBD",
                @"PHYSIC_DB":@"PHYSIC_DB",
                @"PKIND_S":@"PKIND_S",
                @"PN":@"PN",
                @"TITLE":@"TITLE",
                @"VALID":@"VALID",
                @"value":@"patentFee",
             };
}
@end
