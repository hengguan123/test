//
//  RankingViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "RankingViewController.h"

@interface RankingViewController ()<WKUIDelegate,WKNavigationDelegate>

@property(nonatomic,strong)WKWebView *webView;

@end

@implementation RankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    if (@available(iOS 11.0, *))
    {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    NSURL *url= [NSURL URLWithString:[[NSString stringWithFormat:@"%@%@",HTTPURL,@"/patent/rankList"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:5];
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    [self.webView loadRequest:request];
}

-(void)back
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else
    {
        [self cleanCacheAndCookie];
        [self.navigationController popViewControllerAnimated:YES];
    }
}
/**清除缓存和cookie*/
- (void)cleanCacheAndCookie{
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    //// Date from
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    //// Execute
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
        // Done
        
    }];
}

-(WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64) configuration:config];
        _webView.UIDelegate = self;
        _webView.backgroundColor = UIColorFromRGB(0xf1f2f3);
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(0);
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(0);
                
            } else {
                make.top.equalTo(self.view.mas_top).with.offset(0);
                make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            }
        }];
    }
    return _webView;
}
/* 输入框，页面中有调用JS的 prompt 方法就会调用该方法 */

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText
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
    NSLog(@"URL-----%@",webView.URL.absoluteString);
    [LoadingManager dismiss];
    self.navigationItem.title = webView.title;
}
/* 3.在收到服务器的响应头，根据response相关信息，决定是否跳转。 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    decisionHandler(WKNavigationResponsePolicyAllow);
}
/* 1.在发送请求之前，决定是否跳转  */

- (void)webView:(WKWebView *)webView

decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler

{
    //如果是跳转一个新页面
    
    if (navigationAction.targetFrame == nil) {
        
        [webView loadRequest:navigationAction.request];
        
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
    
}

@end
