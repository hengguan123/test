//
//  AgentInfoModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface AgentInfoModel : MTLModel <MTLJSONSerializing>

/// 昵称
@property(nonatomic,copy)NSString *facilitatorName;
/// 头像
@property(nonatomic,copy)NSString *portraitUrl;
@property(nonatomic,strong)NSNumber *facilitatorId;
///代理证
@property(nonatomic,copy)NSString *credUrl;

@property(nonatomic,copy)NSString *dwellAddr;
/// 手机号
@property(nonatomic,copy)NSString *mobilePhone;
@property(nonatomic,copy)NSString *qq;

///身份证AB
@property(nonatomic,copy)NSString *fileUrl1;
@property(nonatomic,copy)NSString *fileUrl2;

///银行卡账号、开户行、归属地
@property(nonatomic,copy)NSString *bankCardNo;
@property(nonatomic,copy)NSString *bankOpen;
@property(nonatomic,copy)NSString *bankLocale;
///宣言、简介、其他
@property(nonatomic,copy)NSString *serveManifesto;
@property(nonatomic,copy)NSString *serveBrief;
@property(nonatomic,copy)NSString *ortherInfo;


/// 真实姓名
@property(nonatomic,copy)NSString *realName;
/// 年检状态 0_未提交 1_已提交
@property(nonatomic,copy)NSString *annualStatus;
/// 执业证号
@property(nonatomic,copy)NSString *practCertNo;
/// 资格证号
@property(nonatomic,copy)NSString *qualCertNo;
/// 所在机构
@property(nonatomic,copy)NSString *companyName;
/// 机构代码
@property(nonatomic,copy)NSString *organNo;
/// 邮项
@property(nonatomic,copy)NSString *email;

@end
