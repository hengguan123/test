//
//  AppUserDefaults.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/5/23.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AppUserDefaults.h"

@implementation AppUserDefaults

static AppUserDefaults *_userDefaults;
+(AppUserDefaults *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _userDefaults = [[AppUserDefaults alloc]init];
    });
    return _userDefaults;
}
-(void)releaseAll
{
    self.login =NO;
    self.usrId = nil;
    self.userName = nil;
    self.specialUser = NO;
    self.phone = nil;
    self.isInside = nil;
}



-(void)setLogin:(BOOL)login
{
    [[NSUserDefaults standardUserDefaults]setBool:login forKey:@"login"];
}

-(BOOL)isLogin
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"login"];
}

-(void)setUsrId:(NSNumber *)usrId
{
    [[NSUserDefaults standardUserDefaults]setObject:usrId forKey:@"usrId"];
}
-(NSNumber *)usrId
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"usrId"];
}

-(NSArray *)provinceArray
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Area" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:plistPath];
    if (array) {
        return [MTLJSONAdapter modelsOfClass:[AreaModel class] fromJSONArray:array error:nil];
    }
    else
    {
        return nil;
    }
}
-(NSDictionary *)trademarkType
{
    if (!_trademarkType) {
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"TrademarkType" ofType:@"plist"];
        _trademarkType = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    }
    return _trademarkType;
    
}
-(void)setSpecialUser:(BOOL)specialUser
{
    [[NSUserDefaults standardUserDefaults]setBool:specialUser forKey:@"specialUser"];
}

-(BOOL)isSpecialUser
{
    return [[NSUserDefaults standardUserDefaults]boolForKey:@"specialUser"];
}

-(void)setUserName:(NSString *)userName
{
    [[NSUserDefaults standardUserDefaults]setValue:userName forKey:@"userName"];
}
-(NSString *)userName
{
    return [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"];
}

-(void)setPhone:(NSString *)phone
{
    [[NSUserDefaults standardUserDefaults]setValue:phone forKey:@"phone"];
}
-(NSString *)phone
{
    return [[NSUserDefaults standardUserDefaults]valueForKey:@"phone"];
}

-(void)setMainColor:(unsigned long)mainColor
{
    [[NSUserDefaults standardUserDefaults]setDouble:mainColor forKey:@"mainColor"];
}
-(unsigned long)mainColor
{
    return [[NSUserDefaults standardUserDefaults]doubleForKey:@"mainColor"];
}

-(void)setBannerArr:(NSArray *)bannerArr
{
    NSMutableArray *copeArray = [bannerArr mutableCopy];//深拷贝数组文件
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:copeArray];
   
    [[NSUserDefaults standardUserDefaults]setObject:data forKey:@"bannerArr"];
}
-(NSArray *)bannerArr
{
    NSData *data= [[NSUserDefaults standardUserDefaults]objectForKey:@"bannerArr" ];
    if (!data) {
        return [NSArray new];
    }
    NSArray *array =  [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return array;
}

-(void)setSelArea:(NSString *)selArea
{
    [[NSUserDefaults standardUserDefaults]setObject:selArea forKey:@"selArea"];
}
-(NSString *)selArea
{
    return [[NSUserDefaults standardUserDefaults]valueForKey:@"selArea"];
}
-(void)setIsInside:(NSString *)isInside
{
    [[NSUserDefaults standardUserDefaults]setObject:isInside forKey:@"isInside"];
}
-(NSString *)isInside
{
    return [[NSUserDefaults standardUserDefaults]valueForKey:@"isInside"];
}
//-(void)setProducitonURL:(NSString *)producitonURL
//{
//    [[NSUserDefaults standardUserDefaults]setObject:producitonURL forKey:@"producitonURL"];
//}
//-(NSString *)producitonURL
//{
//    return [[NSUserDefaults standardUserDefaults]valueForKey:@"producitonURL"];
//}
//
-(void)setYkId:(NSNumber *)ykId
{
    [[NSUserDefaults standardUserDefaults]setObject:ykId forKey:@"ykId"];
}
-(NSNumber *)ykId
{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"ykId"];
}


@end
