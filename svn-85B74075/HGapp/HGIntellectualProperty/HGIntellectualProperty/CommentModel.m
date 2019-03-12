//
//  CommentModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"evalContent":@"evalContent",
                @"domainName":@"domainName",
                @"errandTypeName":@"errandTypeName",
                @"busiTypeName":@"busiTypeName",
                @"evalLevel":@"evalLevel",
                @"provinceName":@"provinceName",
                @"cityName":@"cityName",
                @"createTime":@"createTime",
                @"usrAlias":@"usrAlias",
                @"portraitUrl":@"portraitUrl",
             };
}

@end
