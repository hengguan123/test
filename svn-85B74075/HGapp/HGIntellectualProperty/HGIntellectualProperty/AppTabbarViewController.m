//
//  AppTabbarViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/1.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AppTabbarViewController.h"
#import "BecomeAgentViewController.h"

static AppTabbarViewController *SINGLEVC;
@interface AppTabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation AppTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    SINGLEVC = self;
    self.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(logout) name:LogoutNoti object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(policyInformation:) name:OpenPolicyInformationNoti object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(becomeAgent:) name:OpenBecomeAgentNoti object:nil];
}



+(instancetype)share
{
    return SINGLEVC;
}

//-(void)becomeAgent:(NSNotification *)noti
//{
//    NSDictionary *info = noti.object;
//    NSString *fromUid = [info objectForKey:@"fromUid"];
//    BecomeAgentViewController *becomeVc = [[BecomeAgentViewController alloc]init];
//    becomeVc.fromInvite = YES;
//    becomeVc.fromUid = fromUid;
//    [self.navigationController pushViewController:becomeVc animated:YES ];
//    becomeVc.hidesBottomBarWhenPushed = YES;
//    UINavigationController *nav = [self.viewControllers objectAtIndex:self.selectedIndex];
//    [nav pushViewController:becomeVc animated:YES];
//}

-(void)policyInformation:(NSNotification *)noti
{
    
    NSDictionary *info = noti.object;
    if ([[info objectForKey:@"type"]isEqualToString:@"policyInformation"]) {
        NSString *title = [info objectForKey:@"title"];
        NSString *policyId = [info objectForKey:@"id"];
        NSString *addr = [info objectForKey:@"addr"];
        NSString *source = [info objectForKey:@"sorce"];
        NSString *pubDate = [info objectForKey:@"pubDate"];
        
        HTMLViewController *view = [[HTMLViewController alloc]init];
        view.htmlUrl = [HTTPURL stringByAppendingFormat:@"/granoti/info?id=%@&addr=%@&source=%@",policyId,addr,source];
        view.titleStr = title?:@"";
        view.canShare = YES;
        view.addr = addr?:@"";
        view.source = source?:@"";
        view.pubtime = pubDate?:@"";
        view.hidesBottomBarWhenPushed = YES;
        UINavigationController *nav = [self.viewControllers objectAtIndex:self.selectedIndex];
        [nav pushViewController:view animated:YES];
    }
    else if ([[info objectForKey:@"type"]isEqualToString:@"replyInformation"])
    {
        NSString *busiQuality = [info objectForKey:@"busiQuality"];
        NSString *infoId = [info objectForKey:@"paramId"];
        HTMLViewController *vc = [[HTMLViewController alloc]init];
        vc.titleStr = @"交易信息";
        vc.htmlUrl = [NSString stringWithFormat:@"%@/business/intentionList?id=%@&usrPhone=%@&busiQuality=%@",HTTPURL,infoId,[AppUserDefaults share].phone?[AppUserDefaults share].phone:@"",busiQuality];
        
        UINavigationController *nav = [self.viewControllers objectAtIndex:self.selectedIndex];
        [nav pushViewController:vc animated:YES];
    }
    
}

- (void)logout
{
    [[AppUserDefaults share]releaseAll];
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
    [JPUSHService cleanTags:^(NSInteger iResCode, NSSet *iTags, NSInteger seq) {
        
    } seq:1];
    [self setSelectedIndex:0];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([AppUserDefaults share].login) {
        return YES;
    }
    else
    {
        if (tabBarController.viewControllers.firstObject == viewController) {
            return YES;
        }
        else
        {
            [self goToLogin];
            return NO;
        }
        
    }
}

-(void)goToLogin
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}

@end
