//
//  CutoverManager.m
//  HGIntellectualProperty
//  页面切换管理器
//  Created by 耿广杰 on 2017/7/26.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CutoverManager.h"
#import "CopyrightDetailsViewController.h"
#import "PreviewViewController.h"

@implementation CutoverManager

+(instancetype)share
{
    static CutoverManager *manger = nil;
    static dispatch_once_t onceToken2;
    dispatch_once(&onceToken2, ^{
        manger = [[CutoverManager alloc] init];
    });
    return manger;
}

+(void)openPatendDetailWithFromController:(UIViewController *)vc techId:(NSString *)patentId physicDb:(NSString *)physicDb PKINDS:(NSString *)PKINDS monitorId:(NSNumber *)monitorId title:(NSString *)patentTitle subTitle:(NSString *)patentAN share:(BOOL)enableShare
{
    if ([AppUserDefaults share].isLogin) {
        NSMutableString *url = [[NSMutableString alloc]initWithFormat:@"%@%@%@",HTTPURL,@"/patent/info?usrId=",[AppUserDefaults share].usrId];
        [url appendFormat:@"&techId=%@&physicDb=%@&PKINDS=%@&app=1",patentId,physicDb,PKINDS];
        if (monitorId) {
            [url appendFormat:@"&monitorId=%@",monitorId];
        }
        WebViewController *webview = [[WebViewController alloc]init];
        webview.sharePatent = enableShare;
        webview.urlStr = url;
        webview.titleStr = @"专利详情";
        webview.physicDb = physicDb;
        webview.shareTitile = patentTitle;
        webview.shareSubTitile = patentAN;
        webview.hidesBottomBarWhenPushed = YES;
        [vc showViewController:webview sender:vc];
    }
    else{
        [self goToLoginFromVC:vc];
    }
}

+(void)openTrademarkDetailWithFromController:(UIViewController *)vc regNo:(NSString *)regNo intCls:(NSString *)intCls name:(NSString *)name owner:(NSString *)owner usrPhone:(NSString *)usrPhone
{
    if ([AppUserDefaults share].isLogin) {
        NSMutableString *url = [[NSMutableString alloc]initWithFormat:@"%@%@",HTTPURL,@"/trademark/info?"];
        [url appendFormat:@"regNo=%@&intCls=%@&usrPhone=%@&tradeTypeName=%@&usrName=%@",regNo,intCls,usrPhone,[[AppUserDefaults share].trademarkType objectForKey:intCls],[AppUserDefaults share].userName];
//        if (monitorId) {
//            [url appendFormat:@"&monitorId=%@",monitorId];
//        }
        
        WebViewController *webview = [[WebViewController alloc]init];
        webview.urlStr = url;
        webview.titleStr = @"商标详情";
        webview.shareTradeMark = YES;
        webview.shareTitile = [NSString stringWithFormat:@"%@ 第%@类",name,intCls];
        webview.shareSubTitile = owner;
        [vc showViewController:webview sender:vc];
    }
    else
    {
        [self goToLoginFromVC:vc];
    }
}

+(void)openCopyrightDetailWithFromController:(UIViewController *)fromvc softwareModel:(SoftwareCopyrightModel *)softwareModel worksModel:(WorksCopyrightModel *)worksModel
{
//    if ([AppUserDefaults share].isLogin) {
        CopyrightDetailsViewController *vc = [[CopyrightDetailsViewController alloc]initWithNibName:@"CopyrightDetailsViewController" bundle:nil];
        if (softwareModel) {
            vc.softModel = softwareModel;
        }
        if (worksModel) {
            vc.worksModel = worksModel;
        }
        [fromvc.navigationController pushViewController:vc animated:YES];
//    }
//    else
//    {
//        [self goToLoginFromVC:fromvc];
//    }
}



+(void)goToLoginFromVC:(UIViewController *)fromVc
{
    LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [fromVc presentViewController:nav animated:YES completion:nil];
}


+(void)downloadAndOpenFileWithUrl:(NSString *)url fromController:(UIViewController *)fromVc
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //    http://jxw.bjtzh.gov.cn/n13135561/c15043965/part/15043977.xls
    //    http://www.bjkw.gov.cn/module/download/downfile.jsp?classid=0&filename=28453e6e7633433c9d7b820b57c2b216.doc
    //    http://fgw.bjfsh.gov.cn/docs/2017-09/20170907110102683582.pdf
    NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    [LoadingManager show];
    NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    NSString *Extension = [URL.absoluteString pathExtension];
    NSError *error;
    [[NSFileManager defaultManager]removeItemAtPath:[[documentsDirectoryURL.absoluteString stringByAppendingFormat:@"1.%@",Extension] substringFromIndex:7] error:&error];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"%f",downloadProgress.completedUnitCount*1.0/downloadProgress.totalUnitCount);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"1.%@",Extension]];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [LoadingManager dismiss];
        if (!error) {
            NSLog(@"File downloaded to: %@",filePath.absoluteString);
            NSString *path = [filePath.absoluteString substringFromIndex:0];
            PreviewViewController *vc = [[PreviewViewController alloc]init];
            vc.path  = path;
            [fromVc.navigationController pushViewController:vc animated:YES];
        }
        else
        {
            [SVProgressHUD showErrorWithStatus:@"附件下载失败"];
        }
        
    }];
    
    [downloadTask resume];
}



@end
