//
//  MyPatentModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/28.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MyPatentModel.h"

@implementation MyPatentModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"patentPn":@"patentPn",
             @"patentName":@"patentName",
             @"pkind":@"pkind",
             @"company":@"reseField2",
             @"patentId":@"patentId",
             @"person":@"reseField1",
             @"pkinds":@"pkinds",
             @"dbName":@"dbName",
             };
}



@end
