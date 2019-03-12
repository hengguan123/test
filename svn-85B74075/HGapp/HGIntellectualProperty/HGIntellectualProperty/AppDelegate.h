//
//  AppDelegate.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/5/22.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppUserDefaults.h"
#import "UserInfo.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property(nonatomic,assign,readonly)NSInteger netWorkSatus;
@property(nonatomic,copy)NSString *locationCity;
@property(nonatomic,strong)UserInfo *userInfo;

@property(nonatomic,copy)NSString *homeCity;


- (void)saveContext;


@end

