//
//  UserInfo.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/20.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"usrAlias":@"usr.usrAlias",
                @"usrType":@"usr.usrType",
                @"reseField1":@"reseField1",
                @"usrAccount":@"usr.usrAccount",
                @"wxAccount":@"usr.wxAccount",
                @"qqAccount":@"usr.qqAccount",
                @"soldPay":@"usr.soldPay",
                @"portraitUrl":@"usr.portraitUrl",
                @"upInvitCode":@"usr.upInvitCode",
                @"invitationCode":@"usr.invitationCode",
                @"integral":@"usr.integral",
                @"evalCount":@"evalCount",
                @"faciUnderwayCount":@"faciUnderwayCount",
                @"finishCount":@"finishCount",
                @"generalUnderwayCount":@"generalUnderwayCount",
                @"publishCount":@"publishCount",
                @"robErrandCount":@"robErrandCount",
                @"unEvalCount":@"unEvalCount",
                @"unReadCount":@"unReadCount",
                @"unPayCount":@"unPayCount",
                @"underwayCount":@"underwayCount",
                @"facilitatorId":@"faci.facilitatorId",
                @"faciCityCode":@"faci.dwellAddr",
                @"faciCity":@"faci.dwellAddrName",
                @"userCity":@"usrDetails.cityName",
                @"userCityCode":@"usrDetails.city",
                @"detailsId":@"usrDetails.detailsId",
                @"evalMeCount":@"evalMeCount",
                @"unWithdrawPrice":@"unWithdrawPrice",
                @"bankCardNo":@"faci.bankCardNo",
                @"bankOpen":@"faci.bankOpen",
                @"bankLocale":@"faci.bankLocale",
                @"payCount":@"payCount",
                @"shopCount":@"shopCount",
                @"isInside":@"usr.isInside",
                @"isReceOrder":@"faci.isReceOrder",
             };
}


@end
