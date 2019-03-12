//
//  GGTool.m
//  Buy_user
//
//  Created by 耿广杰 on 2017/4/19.
//  Copyright © 2017年 GG. All rights reserved.
//

#import "GGTool.h"

@interface GGTool()<CLLocationManagerDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)CLLocationManager *locMgr;
@end

@implementation GGTool
{
    SuccessHandler _success;
}
/**
 *  正则判断是否为手机号
 *
 *  @param mobileNum 手机号
 *
 *  @return YES NO
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[0, 1, 6, 7, 8], 18[0-9]
     * 移动号段: 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     * 联通号段: 130,131,132,145,152,155,156,170,171,175,176,185,186
     * 电信号段: 133,134,153,170,177,180,181,189
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|7[01678]|8[0-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,147,150,151,152,157,158,159,170,178,182,183,184,187,188
     */
    NSString *CM = @"^1(3[4-9]|4[7]|5[0-27-9]|7[08]|8[2-478])\\d{8}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,145,152,155,156,170,171,175,176,185,186,166
     */
    NSString *CU = @"^1(3[0-2]|4[5]|5[256]|6[6]|7[0156]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,134,153,170,173,177,180,181,189
     */
    NSString *CT = @"^1(3[34]|53|7[037]|8[019])\\d{8}$";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}
/// 判断是否有数字0-9 一-九 壹-玖
+ (BOOL)isContainNumStr:(NSString *)str
{
    NSString *rule = @"[0-9\u96f6\u4e00\u4e8c\u4e09\u56db\u4e94\u516d\u4e03\u516b\u4e5d\u58f9\u8d30\u53c1\u8086\u4f0d\u9646\u67d2\u634c\u7396\u5341\u62fe]";
    NSRegularExpression *regu = [[NSRegularExpression alloc]initWithPattern:rule options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSInteger num = [regu numberOfMatchesInString:str options:0 range:NSMakeRange(0, str.length)];
    if (num>0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

//MD5
+(NSString *)md5:(NSString *)strSource{
    
    const char *cStr = [strSource UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output.uppercaseString;
}


+(instancetype)share
{
    static GGTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[GGTool alloc] init];
    });
    return tool;
}

-(void)getLocationSuccessHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorBlock
{
    //    if ([self.locMgr respondsToSelector:@selector(requestAlwaysAuthorization)]) {
    //        NSLog(@"requestAlwaysAuthorization");
    //        [self.locMgr requestAlwaysAuthorization];
    //    }
    _success =handler;
    if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusNotDetermined){
        [self.locMgr requestAlwaysAuthorization];// 当使用app时获取位置
        [self.locMgr startUpdatingLocation];
    }
    else
    {
        BOOL alll=[CLLocationManager locationServicesEnabled]&&([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways|| [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse);
        if (alll)
        {
            //开始定位用户的位置
            [self.locMgr startUpdatingLocation];
            //每隔多少米定位一次（这里的设置为任何的移动）
            self.locMgr.distanceFilter=10;
            //设置定位的精准度，一般精准度越高，越耗电（这里设置为精准度最高的，适用于导航应用）
            self.locMgr.desiredAccuracy=kCLLocationAccuracyHundredMeters;
        }
        else
        {   //不能定位用户的位置
            //1.提醒用户检查当前的网络状况
            //2.提醒用户打开定位开关
            UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"警告" message:@"当前应用定位服务未开启,是否跳转开启" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            alertView.tag = 103;
            [alertView show];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSLog(@"hehe");
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

/**
 *  系统定位
 *
 *  @return nil
 */
-(CLLocationManager *)locMgr
{
    if(!_locMgr)
    {
        _locMgr=[[CLLocationManager alloc]init];
        _locMgr.delegate=self;
    }
    return _locMgr;
}

#pragma mark-CLLocationManagerDelegate
/**
 *  当定位到用户的位置时，就会调用（调用的频率比较频繁）
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //locations数组里边存放的是CLLocation对象，一个CLLocation对象就代表着一个位置
    CLLocation *loc = [locations firstObject];
    
    //维度：loc.coordinate.latitude
    //经度：loc.coordinate.longitude
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    // 反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (! error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks firstObject];
                // 获取城市
                if (_success) {
                    NSString * s=placemark.administrativeArea;
                _success(placemark.administrativeArea,placemark.locality,loc);
                }
                _currentCity = placemark.locality;
                _currentProvince = placemark.administrativeArea;
                MyApp.locationCity = placemark.locality;
                
            } else if ([placemarks count] == 0) {
                
            }
        } else {
            
        }
    }];
    //停止更新位置（如果定位服务不需要实时更新的话，那么应该停止位置的更新）
    [self.locMgr stopUpdatingLocation];
}

+(double)distanceBetweenOnePointlatitude:(double)latitude1 longitude:(double)longitude1 twoPointlatitude:(double)latitude2 longitude:(double)longitude2{
    
    CLLocation* curLocation = [[CLLocation alloc] initWithLatitude:latitude1 longitude:longitude1];
    CLLocation* otherLocation = [[CLLocation alloc] initWithLatitude:latitude2 longitude:longitude2];
    CLLocationDistance distance  = [curLocation distanceFromLocation:otherLocation];
    return distance;
}



@end
