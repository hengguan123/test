//
//  CustomerServiceViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/2.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CustomerServiceViewController.h"


@interface CustomerServiceViewController ()<WKUIDelegate,WKNavigationDelegate>

@end

@implementation CustomerServiceViewController
{
//    UIWebView *_webView;
    WKWebView *_wkWebView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationBarBg"] forBarMetrics:UIBarMetricsDefault];
    //4.加载Request
    _wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-49)];
    NSURL *URL = [NSURL URLWithString:CustomerServiceUrl];
    //3.创建Request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    _wkWebView.UIDelegate = self;
    _wkWebView.navigationDelegate = self;
    [_wkWebView loadRequest:request];
    [self.view addSubview:_wkWebView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    NSURL *URL = [NSURL URLWithString:CustomerServiceUrl];
    //3.创建Request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [_wkWebView loadRequest:request];
}
/* 输入框，页面中有调用JS的 prompt 方法就会调用该方法 */

- (void)webView:(WKWebView *)webView

runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt

    defaultText:(nullable NSString *)defaultText

initiatedByFrame:(WKFrameInfo *)frame

completionHandler:(void (^)(NSString *result))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.text = defaultText;
        
    }];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(alertController.textFields[0].text?:@"");
        
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

/* 确认框，页面中有调用JS的 confirm 方法就会调用该方法 */

- (void)webView:(WKWebView *)webView

runJavaScriptConfirmPanelWithMessage:(NSString *)message

initiatedByFrame:(WKFrameInfo *)frame

completionHandler:(void (^)(BOOL result))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(NO);
        
    }])];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler(YES);
        
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

/* 警告框，页面中有调用JS的 alert 方法就会调用该方法 */

- (void)webView:(WKWebView *)webView

runJavaScriptAlertPanelWithMessage:(NSString *)message

initiatedByFrame:(WKFrameInfo *)frame

completionHandler:(void (^)(void))completionHandler{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        completionHandler();
        
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [LoadingManager show];
}
-(void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation
{
    [LoadingManager dismiss];
}

@end
