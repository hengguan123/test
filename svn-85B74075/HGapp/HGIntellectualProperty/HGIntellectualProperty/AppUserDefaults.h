//
//  AppUserDefaults.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/5/23.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUserDefaults : NSObject

@property(nonatomic,assign,getter=isLogin)BOOL login;
@property(nonatomic,strong)NSNumber *usrId;
@property(nonatomic,strong,readonly)NSArray *provinceArray;
/// 是不是代理人
@property(nonatomic,assign,getter=isSpecialUser)BOOL specialUser;
@property(nonatomic,copy)NSString *userName;
@property(nonatomic,strong)NSNumber *facilitatorId;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,assign)unsigned long mainColor;

@property(nonatomic,assign)BOOL allowMoreInfo;

@property(nonatomic,strong)NSArray *bannerArr;
@property(nonatomic,strong)NSDictionary *trademarkType;
///财政资金申报-选择地点
@property(nonatomic,copy)NSString *selArea;
///游客id
@property(nonatomic,strong)NSNumber *ykId;
///账号类型  noType
//@property(nonatomic,strong)NSString *noType;


///// 来自服务端的发布接口
//@property(nonatomic,copy)NSString *producitonURL;
///// 来自服务端的开发接口
//@property(nonatomic,copy)NSString *developerURL;

@property(nonatomic,assign)BOOL isShowVersion;
/// 是否内部帐号<IS_INSIDE> 0_普通用户 1_内部用户
@property(nonatomic,copy)NSString *isInside;
/// 用户类型  userType 1-代理人
@property(nonatomic,copy)NSString *userType;

+(AppUserDefaults *)share;
-(void)releaseAll;

@end
