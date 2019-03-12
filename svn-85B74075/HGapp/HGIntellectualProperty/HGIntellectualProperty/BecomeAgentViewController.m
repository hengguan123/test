//
//  BecomeAgentViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/9.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "BecomeAgentViewController.h"
#import "RequestURL.h"


@interface BecomeAgentViewController ()<WKUIDelegate,WKNavigationDelegate>
@property (strong, nonatomic)  WKWebView *webView;

@end

@implementation BecomeAgentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = @"成为代理人";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    //2.创建URL
    NSURL *URL;
    if (self.isFromInvite) {
        URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@",HTTPURL,@"/faci/join?fromUid=",self.fromUid]];
    }
    else
    {
        if ([AppUserDefaults share].isLogin) {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@/faci/join?usrId=%@",HTTPURL,AppUserDefaults.share.usrId]];
        }
        else
        {
            URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",HTTPURL,@"/faci/join"]];
        }
    }
    //3.创建Request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //4.加载Request
    _webView.UIDelegate = self;
    _webView.navigationDelegate =self;
    [self.webView loadRequest:request];
    [self.view addSubview:_webView];
}
- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler{
    
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

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    
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

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([message isEqualToString:@"提交成功"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        completionHandler();
        
    }])];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
