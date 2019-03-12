//
//  UserInfo.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/20.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UserInfo : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *usrAlias;
@property(nonatomic,copy)NSString *usrType;
//@property(nonatomic,copy)NSString *noType;
@property(nonatomic,copy)NSString *reseField1;//手机号

@property(nonatomic,strong)NSNumber *soldPay;//差响
@property(nonatomic,copy)NSString *portraitUrl;
@property(nonatomic,copy)NSString *upInvitCode;//邀请人的码
@property(nonatomic,copy)NSString *invitationCode;//邀请码
@property(nonatomic,strong)NSNumber *integral;//积分

@property(nonatomic,strong)NSNumber *evalCount;//评价数
@property(nonatomic,strong)NSNumber *faciUnderwayCount;//代理进行中
@property(nonatomic,strong)NSNumber *evalMeCount;//评价我的数
@property(nonatomic,strong)NSNumber *finishCount;//完成的
@property(nonatomic,strong)NSNumber *generalUnderwayCount;//发布差事进行中的数量
@property(nonatomic,strong)NSNumber *publishCount;//发布的
@property(nonatomic,strong)NSNumber *robErrandCount;//抢的
@property(nonatomic,strong)NSNumber *unEvalCount;//未评价
@property(nonatomic,strong)NSNumber *unReadCount;//未读数
@property(nonatomic,strong)NSNumber *unPayCount;//未支付
@property(nonatomic,strong)NSNumber *underwayCount;//进行中

@property(nonatomic,copy)NSString *faciCity;
@property(nonatomic,copy)NSString *faciCityCode;

@property(nonatomic,copy)NSString *userCity;
@property(nonatomic,copy)NSString *userCityCode;

@property(nonatomic,strong)NSNumber *facilitatorId;
@property(nonatomic,strong)NSNumber *detailsId;
@property(nonatomic,strong)NSNumber *unWithdrawPrice;
@property(nonatomic,copy)NSString *bankCardNo;
@property(nonatomic,copy)NSString *bankLocale;
@property(nonatomic,copy)NSString *bankOpen;
/// 已支付数量
@property(nonatomic,strong)NSNumber *payCount;
/// 购物车数量
@property(nonatomic,strong)NSNumber *shopCount;
/// 是否为内部用户
@property(nonatomic,copy)NSString *isInside;
@property(nonatomic,copy)NSString *isReceOrder;
///登录手机号
@property(nonatomic,copy)NSString *usrAccount;
///微信唯一标识
@property(nonatomic,copy)NSString *wxAccount;
///QQ唯一标识
@property(nonatomic,copy)NSString *qqAccount;




@end
