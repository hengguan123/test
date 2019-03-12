//
//  VersionManager.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/9.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "VersionManager.h"

@interface VersionManager ()


@end
@implementation VersionManager

+(void)showVersionWithModel:(VersionModel *)model
{
    AppUserDefaults.share.isShowVersion = YES;
    [SVProgressHUD dismiss];
    UIView *versionBgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    versionBgView.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
    
    UIView * versionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 300, 400)];
    versionView.center = versionBgView.center;
    versionView.layer.cornerRadius = 10;
    versionView.backgroundColor = [UIColor whiteColor];
    [versionBgView addSubview:versionView];
    [MyApp.window addSubview:versionBgView];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 300, 24)];
    titleLab.text = @"版本更新提示";
    titleLab.textAlignment = 1;
    
    [versionView addSubview:titleLab];
    
    UILabel *versionnLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 40, 300, 18)];
    versionnLab.text = [@"新版本 " stringByAppendingString:model.versionNo];
    versionnLab.textColor = MainColor;
    versionnLab.textAlignment = 1;
    versionnLab.font = [UIFont systemFontOfSize:14];
    [versionView addSubview:versionnLab];
    

    NSString *strHTML = model.versionInfo;
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(15, 65, 270, 275)];
    [versionView addSubview:webView];
    webView.backgroundColor = [UIColor clearColor];
    [webView loadHTMLString:strHTML baseURL:nil];
    
    UILabel *upDataLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 350, 240, 40)];
    upDataLab.layer.cornerRadius = 5;
    upDataLab.layer.masksToBounds = YES;
    upDataLab.backgroundColor = MainColor;
    upDataLab.text = @"去更新";
    upDataLab.textAlignment = 1;
    upDataLab.textColor = [UIColor whiteColor];
    upDataLab.userInteractionEnabled = YES;
    [versionView addSubview:upDataLab];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(gotoupdata)];
    [upDataLab addGestureRecognizer:tap];
    
}

+ (void)gotoupdata
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/%E6%81%92%E5%86%A0%E7%9F%A5%E8%AF%86%E4%BA%A7%E6%9D%83/id1243906361?mt=8"]];
}
@end
