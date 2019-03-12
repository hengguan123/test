//
//  AppDelegate.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/5/22.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkReachabilityManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "XHLaunchAd.h"
#import "Request.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@interface AppDelegate ()<JPUSHRegisterDelegate,WXApiDelegate,AMapLocationManagerDelegate>

@property(nonatomic,strong)AMapLocationManager *locationManager;

@end

@implementation AppDelegate
{
    BOOL _isActive;//活跃状态
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    jpush
    //Required
    [self loadAdView];
    
    _isActive = YES;
    
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"71fe3bbe325144b19d685538"
                          channel:@"App Store"
                 apsForProduction:NO
            advertisingIdentifier:nil];
    
    UMConfigInstance.appKey = @"59292db1677baa39b1000ce0";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"59292db1677baa39b1000ce0"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx9d6b03a8272918b9" appSecret:@"fa5d421948cb1324c5105b4019afc503" redirectURL:@"http://mobile.umeng.com/social"];
    /*设置QQ平台的appID*/
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106191464"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"1464434542"  appSecret:@"8e66bd39737de855ed0e9d9096f2ebd0" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),
        @(UMSocialPlatformType_Sina)
    ]];
    [MobClick event:@"startup"];

    [[DBManager share]creatDB];
    [self setColorWithPromptBox];
    [self configLocationManager];
    [AMapServices sharedServices].apiKey =@"da6c87c3b76c5d1ace4399bfddd5ce97";
    
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    assert(uuid != NULL);
    CFStringRef uuidStr = CFUUIDCreateString(NULL, uuid);
    //    然后，从钥匙串读取UUID：
    NSString *retrieveuuid = [SSKeychain passwordForService:@"com.techhg.HGIntellectualProperty"account:@"useruuid"];
    if (retrieveuuid == nil) {
        [SSKeychain setPassword: [NSString stringWithFormat:@"%@", uuidStr]forService:@"com.techhg.HGIntellectualProperty"account:@"useruuid"];
    }
    NSLog(@"uuid:%@",retrieveuuid);
    
    if ([AppUserDefaults share].isLogin) {
        [MobClick profileSignInWithPUID:[NSString stringWithFormat:@"用户%@",[AppUserDefaults share].usrId]];
        NSSet *set = [[NSSet alloc]initWithObjects:[NSString stringWithFormat:@"%@",[AppUserDefaults share].usrId], nil];
        [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
            if (iResCode==0) {
                
            }
            else
            {
                [JPUSHService setTags:set completion:nil seq:2];
            }
        } seq:1];
        _isActive = YES;
    }
    else
    {
        if ([AppUserDefaults share].ykId) {
            _isActive = YES;
        }
        else
        {
            [RequestManager registeredTouristsWithUUid:retrieveuuid successHandler:^(NSNumber *ykid) {
                _isActive = YES;
                NSSet *set = [[NSSet alloc]initWithObjects:[NSString stringWithFormat:@"yk%@",[AppUserDefaults share].ykId], nil];
                [JPUSHService setTags:set completion:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
                    if (iResCode==0) {
                        
                    }
                    else
                    {
                        [JPUSHService setTags:set completion:nil seq:2];
                    }
                } seq:1];
            } errorHandler:^(NSError *error) {
                
            }];
        }
    }
    [self getNetWorkStatus];
    AppUserDefaults.share.allowMoreInfo = YES;
    
    [self identityCheck];

    
    
    return YES;
}


///定位初始化
- (void)configLocationManager
{
    self.locationManager = [[AMapLocationManager alloc] init];
    [self.locationManager setDelegate:self];
    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout =5;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    //设置不允许系统暂停定位
    [self.locationManager setPausesLocationUpdatesAutomatically:NO];
    self.locationManager.locatingWithReGeocode = YES;
    //设置允许在后台定位
    [self.locationManager setAllowsBackgroundLocationUpdates:NO];
    [self.locationManager startUpdatingLocation];
}

-(void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode
{
    NSLog(@"%f----%f  %@",location.coordinate.longitude,location.coordinate.latitude,reGeocode.city);
    NSString *time = [self getCurrentTimes];
    if (reGeocode) {
        if ([time hasPrefix:@"10:00"]||[time hasPrefix:@"14:00"]||[time hasPrefix:@"22:00"]||_isActive) {
            self.homeCity = reGeocode.province;
            _isActive = NO;
            if ([AppUserDefaults share].isLogin) {
                [RequestManager submitPositionWithusrId:[AppUserDefaults share].usrId addrState:reGeocode.country addrProvince:reGeocode.province addrCity:reGeocode.city addrCounty:reGeocode.district addrDetail:reGeocode.formattedAddress addrLoi:location.coordinate.longitude addrLai:location.coordinate.latitude usrType:@"1" successHandler:^(BOOL success) {
                    
                } errorHandler:^(NSError *error) {
                    
                }];
            }
            else
            {
                if ([AppUserDefaults share].ykId) {
                    [RequestManager submitPositionWithusrId:[AppUserDefaults share].ykId addrState:reGeocode.country addrProvince:reGeocode.province addrCity:reGeocode.city addrCounty:reGeocode.district addrDetail:reGeocode.formattedAddress addrLoi:location.coordinate.longitude addrLai:location.coordinate.latitude usrType:@"0" successHandler:^(BOOL success) {
                        
                    } errorHandler:^(NSError *error) {
                        
                    }];
                }
            }
        }
    }
    
    NSLog(@"%@",[self getCurrentTimes]);
}


-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"HH:mm:ss"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    //----------将nsdate按formatter格式转成nsstring
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSLog(@"currentTimeString =  %@",currentTimeString);
    return currentTimeString;
    
}

//广告页
-(void)loadAdView
{
    //2.自定义配置初始化
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration new];
    //广告停留时间
    imageAdconfiguration.duration = 3;
    //广告frame
    imageAdconfiguration.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    if (XH_IPHONEX) {
        imageAdconfiguration.imageNameOrURLString = @"iphonex_01.png";
    }
    else
    {
        imageAdconfiguration.imageNameOrURLString = @"1242.png";
    }
    //网络图片缓存机制(只对网络图片有效)
    imageAdconfiguration.imageOption = XHLaunchAdImageRefreshCached;
    //图片填充模式
    imageAdconfiguration.contentMode = UIViewContentModeScaleToFill;
    //广告点击打开链接
    imageAdconfiguration.openURLString = @"";
    //广告显示完成动画
    imageAdconfiguration.showFinishAnimate =ShowFinishAnimateFadein;
    //广告显示完成动画时间
    imageAdconfiguration.showFinishAnimateTime = 0.8;
    //跳过按钮类型
    imageAdconfiguration.skipButtonType = SkipTypeTimeText;
    //后台返回时,是否显示广告
    imageAdconfiguration.showEnterForeground = NO;
    
    //设置要添加的子视图(可选)
    //imageAdconfiguration.subViews = ...
    
    //显示图片开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
}

-(void)identityCheck
{
    if ([AppUserDefaults share].isLogin) {
        [RequestManager getUserInfoSuccessHandler:^(NSDictionary *dict) {
            self.userInfo = [MTLJSONAdapter modelOfClass:[UserInfo class] fromJSONDictionary:dict error:nil];
            NSLog(@"%@",dict);
            AppUserDefaults.share.phone = self.userInfo.usrAccount;
        } errorHandler:^(NSError *error) {
            
        }];
    }
}

//-(void)getURLHeader
//{
//    
//}

/**
 *  修改全局提示框颜色
 */
- (void)setColorWithPromptBox
{
    [SVProgressHUD setBackgroundColor:MainColor];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD setMinimumDismissTimeInterval:2.5];
    
//    SVProgressHUD
}
-(void)getNetWorkStatus
{
    _netWorkSatus = 100;//初始
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager ] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                NSLog(@"未知网络");
                break;
            case 0:
                NSLog(@"网络不可达");
                break;
            case 1:
                NSLog(@"GPRS网络");
                break;
            case 2:
                NSLog(@"wifi网络");
                break;
            default:
                break;
        }
        if(status ==AFNetworkReachabilityStatusReachableViaWWAN || status == AFNetworkReachabilityStatusReachableViaWiFi)
        {
            NSLog(@"有网");
            if (self.netWorkSatus == -1||self.netWorkSatus == 0) {
                [NetPromptBox showWithInfo:@"网络已连接" stayTime:3];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"networkrecover" object:nil];
            }
        }else
        {
            [NetPromptBox showWithInfo:@"网络断开连接" stayTime:3];
        }
        _netWorkSatus = status;

    }];
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}


-(void)setHomeCity:(NSString *)homeCity
{
    if (![_homeCity isEqualToString:homeCity]&&homeCity) {
        _homeCity = homeCity;
        [[NSNotificationCenter defaultCenter]postNotificationName:LocationNoti object:nil];
    }
}

//////
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [self processingPush:userInfo];
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    [self processingPush:userInfo];
    completionHandler();  // 系统要求执行这个方法
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [self processingPush:userInfo];
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}
///处理推送
-(void)processingPush:(NSDictionary *)userInfo
{
    NSInteger unread = [self.userInfo.unReadCount integerValue];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:unread];

    NSString *str = [userInfo objectForKey:@"other"];
    if (str) {
        NSData *JSONData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
        if ([responseJSON objectForKey:@"type"]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:OpenPolicyInformationNoti object:responseJSON];
        }
    }
    [JPUSHService resetBadge];
}






- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}







- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    _isActive = YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager]  handleOpenURL:url options:options];
    if (!result) {
        // 其他如支付等SDK的回调
        [WXApi handleOpenURL:url delegate:self];
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }
    }
    return result;
}

// 支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    [WXApi handleOpenURL:url delegate:self];
    return [[UMSocialManager defaultManager] handleOpenURL:url];
}


-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp*)resp;
        [[NSNotificationCenter defaultCenter]postNotificationName:WeChatPayNoti object:nil userInfo:@{@"info":response}];
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"HGIntellectualProperty"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
