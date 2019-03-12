//
//  GGTool.h
//  Buy_user
//
//  Created by 耿广杰 on 2017/4/19.
//  Copyright © 2017年 GG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CommonCrypto/CommonDigest.h>

#define PrivateKey @"CHEHUBANG2016"

@interface GGTool : NSObject

typedef void(^SuccessHandler)(NSString *province,NSString *city,CLLocation *location);
typedef void(^ErrorHandler)(NSError * error);

@property(nonatomic,copy,readonly)NSString *currentCity;
@property(nonatomic,copy,readonly)NSString *currentProvince;

+(instancetype)share;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)isContainNumStr:(NSString *)str;



+(NSString *)md5:(NSString *)strSource;
-(void)getLocationSuccessHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorBlock;;
@end
