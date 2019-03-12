//
//  HTMLViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/11.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HTMLViewController.h"
#import "AgentViewController.h"
#import "PendingPaymentViewController.h"
#import "CountryViewController.h"
#import "FilterManager.h"
#import "AssignAgentTableViewController.h"
#import "PreviewViewController.h"
#import "AFURLSessionManager.h"
#import "CompanyViewController.h"


@interface HTMLViewController ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler>

@property(nonatomic,strong)WKWebView *webView;

@property (nonatomic,strong) CountryViewController *filterVC;

@property (nonatomic,strong)FilterManager *filterManager;

@property (nonatomic,strong)UIBarButtonItem *leftItem1;
@property (nonatomic,strong)UIBarButtonItem *leftItem2;
@property (nonatomic,strong)NSURLSessionDownloadTask *downloadTask ;

@end

@implementation HTMLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:self.naviHidden animated:YES];
    if (self.naviHidden) {
        self.edgesForExtendedLayout = 0;
    }
    if (@available(iOS 11.0, *))
    {
        self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    self.navigationItem.leftBarButtonItems = @[self.leftItem1];
    if (self.rightItem) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"区域" font:13 target:self action:@selector(addCountry)];
    }
    if (self.canShare) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" font:13 target:self action:@selector(share)];
    }
    NSURL *url= [NSURL URLWithString:[self.htmlUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    self.navigationItem.title = self.titleStr;
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    [self.webView loadRequest:request];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(login) name:LoginNodti object:nil];
}

-(UIBarButtonItem *)leftItem1
{
    if (!_leftItem1) {
        _leftItem1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    }
    return _leftItem1;
}
-(UIBarButtonItem *)leftItem2
{
    if (!_leftItem2) {
        _leftItem2 = [[UIBarButtonItem alloc]initWithTitle:@"关闭" font:13 target:self action:@selector(close)];
    }
    return _leftItem2;
}

-(void)login
{
    NSNumber *str = [AppUserDefaults share].usrId;
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"interaction.getUsrId('%@')",str] completionHandler:nil];
}
-(void)back
{
    if (self.downloadTask) {
        [self.downloadTask cancel];
    }
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
    else
    {
        [self cleanCacheAndCookie];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
-(void)close
{
    [self.navigationController popViewControllerAnimated:YES];
    if (self.downloadTask) {
        [self.downloadTask cancel];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
//        config.preferences.minimumFontSize = 18;
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, self.naviHidden?20:0, ScreenWidth, self.naviHidden?ScreenHeight-20:ScreenHeight-64) configuration:config];
        _webView.UIDelegate = self;
        _webView.backgroundColor = UIColorFromRGB(0xf1f2f3);
        _webView.navigationDelegate = self;
        [self.view addSubview:_webView];
        
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view.mas_width).with.offset(0);
            make.left.mas_equalTo(0);
//            make.height.equalTo(self.view.mas_height).with.offset(0);
            if (@available(iOS 11.0, *)) {
                make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).with.offset(0); make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).with.offset(0);
            } else {
                make.top.equalTo(self.view.mas_top).with.offset(0);
                make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            }
        }];
        
//        WKUserContentController *userCC = config.userContentController;
//        //JS调用OC 添加处理脚本
//        [userCC addScriptMessageHandler:self name:@"showMobile"];
//        [userCC addScriptMessageHandler:self name:@"showName"];
//        [userCC addScriptMessageHandler:self name:@"showSendMsg"];
    }
    return _webView;
}

/* 输入框，页面中有调用JS的 prompt 方法就会调用该方法 */

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler{
    
    if (webView.URL.host) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = defaultText;
        }];
        [alertController addAction:([UIAlertAction actionWithTitle:@"完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(alertController.textFields.firstObject.text?:@"");
        }])];
        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(nil);
        }])];
        [self presentViewController:alertController animated:YES completion:nil];

    }
    else
    {
        completionHandler(nil);
    }
}

/* 确认框，页面中有调用JS的 confirm 方法就会调用该方法 */

- (void)webView:(WKWebView *)webView
runJavaScriptConfirmPanelWithMessage:(NSString *)message
initiatedByFrame:(WKFrameInfo *)frame
completionHandler:(void (^)(BOOL result))completionHandler{
    if (webView.URL.host) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:([UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(NO);
        }])];
        [alertController addAction:([UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler(YES);
        }])];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        completionHandler(NO);
    }
}

/* 警告框，页面中有调用JS的 alert 方法就会调用该方法 */

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    if (webView.URL.host) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message?:@"" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            completionHandler();
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            completionHandler();
        }]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        completionHandler();
    }
    
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
    NSLog(@"加载完成了哈+%@",webView.URL.absoluteString);
    if ([self.webView canGoBack]) {
        self.navigationItem.leftBarButtonItems = @[self.leftItem1,self.leftItem2];
    }
    else
    {
        self.navigationItem.leftBarButtonItems = @[self.leftItem1];
    }
}
/* 3.在收到服务器的响应头，根据response相关信息，决定是否跳转。 */

- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%@",navigationResponse.response.URL);
    NSString *str = navigationResponse.response.URL.absoluteString;
    if ([str containsString:@"h5type"]) {
        decisionHandler(WKNavigationResponsePolicyCancel);
        
        [self handelWithUrlParameter:str];

    }
//    if ([self checkFileUrl:str]) {
//        decisionHandler(WKNavigationResponsePolicyCancel);
//        [self downLoadFileWithUrl:str];
//    }
    else
    {
        decisionHandler(WKNavigationResponsePolicyAllow);
    }
}

- (BOOL)checkFileUrl:(NSString *)url
{
    NSArray *extArray = @[@"doc",@"pdf",@"docx",@"xlsx",@"xls",@"png",@"jpg",@"jpeg",@"gif"];
    if (([url hasPrefix:@"http"]||[url hasPrefix:@"https"])&&[extArray containsObject:[url pathExtension].lowercaseString]) {
        return YES;
    }
    return NO;
}
///下载文件
- (void)downLoadFileWithUrl:(NSString *)url
{
    [CutoverManager downloadAndOpenFileWithUrl:url fromController:self];
}



/* 1.在发送请求之前，决定是否跳转  */

- (void)webView:(WKWebView *)webView

decidePolicyForNavigationAction:(nonnull WKNavigationAction *)navigationAction decisionHandler:(nonnull void (^)(WKNavigationActionPolicy))decisionHandler

{
    //如果是跳转一个新页面
    NSLog(@"%@",navigationAction.request.URL);
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
        if ([navigationAction.request.URL.absoluteString hasPrefix:@"tel:"]) {
            [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
            decisionHandler(WKNavigationActionPolicyCancel);
        }
        else
        {
            [webView loadRequest:navigationAction.request];
        }
         decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }

}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
}

/* 4.开始获取到网页内容时返回，需要注入JS，在这里添加 */

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}

-(void)handelWithUrlParameter:(NSString *)url
{
    NSString *str = [[url componentsSeparatedByString:@"?"]lastObject];
    NSArray *parameterArray = [str componentsSeparatedByString:@"&"];
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (NSString *parStr in parameterArray) {
        NSArray *chidlStrArray = [parStr componentsSeparatedByString:@"="];
        NSString * encodedString =[[chidlStrArray lastObject]  stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [dict setValue:encodedString forKey:[chidlStrArray firstObject]];
    }
    if ([parameterArray.firstObject isEqualToString:@"h5type=1"]) {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AgentViewController *vc = [main instantiateViewControllerWithIdentifier:@"AgentViewController"];
        vc.dict = dict;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([parameterArray.firstObject isEqualToString:@"h5type=0"])
    {
        LoginViewController *vc = [[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else if ([parameterArray.firstObject isEqualToString:@"h5type=2"])
    {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PendingPaymentViewController *vc = [main instantiateViewControllerWithIdentifier:@"PendingPaymentViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([parameterArray.firstObject isEqualToString:@"h5type=3"])
    {
        CompanyViewController *vc = [[CompanyViewController alloc]initWithNibName:@"CompanyViewController" bundle:nil];
        vc.dbname = self.physicDb;
        vc.companyName = [dict objectForKey:@"AN"];
        if ([self.titleStr isEqualToString:@"专利详情"]||[self.titleStr isEqualToString:@"费用信息"]) {
            vc.type = 1;
        }
        else if([self.titleStr isEqualToString:@"商标详情"])
        {
            vc.type = 2;
        }
        [self showViewController:vc sender:self];
        
    }
    else if ([parameterArray.firstObject isEqualToString:@"h5type=7"])//存图片
    {
        NSLog(@"%@",dict);
    }
    else if ([parameterArray.firstObject isEqualToString:@"h5type=8"])
    {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AssignAgentTableViewController *vc = [main instantiateViewControllerWithIdentifier:@"AssignAgentTableViewController"];
        vc.dict = dict;
        [self.navigationController showViewController:vc sender:self];
    }
    else if ([parameterArray.firstObject isEqualToString:@"h5type=9"])
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if ([parameterArray.firstObject isEqualToString:@"h5type=9"])
    {
        [self shareWithUrl:[dict objectForKey:@"shareUrl"] subtitle:[dict objectForKey:@"subTitle"]];
    }
    
    
}


#pragma mark Filter
-(void)addCountry
{
    [self.filterManager show];
}
-(FilterManager *)filterManager
{
    if (!_filterManager) {
        CountryViewController *vc = [[CountryViewController alloc]initWithNibName:@"CountryViewController" bundle:nil];
        vc.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        __weak typeof(self) weakSelf = self;
        vc.selCountryBlock = ^(NSString *country) {
            [weakSelf jsCountrys:country];
            [weakSelf.filterManager hidden];
        };
        vc.finishBlock = ^{
            [weakSelf.filterManager hidden];
        };
        _filterManager = [[FilterManager alloc]initWithFilterVc:vc];
    }
    return _filterManager;
}

-(void)jsCountrys:(NSString *)countrys
{
    [self.webView evaluateJavaScript:[NSString stringWithFormat:@"first.country('%@')",countrys] completionHandler:^(id _Nullable ll, NSError * _Nullable error) {
        NSLog(@"error%@",error);
    }];
}

-(void)saveImage:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}
// 指定回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
        NSLog(@"save success");
    }else{
        NSLog(@"save failed");
    }
}


#pragma mark share
-  (void)share
{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWebPageToPlatformType:platformType];
    }];
}
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    
    UMShareWebpageObject *shareObject;
    if (platformType == UMSocialPlatformType_WechatTimeLine) {
        if ([self.addr isEqualToString:@"中央部委"]) {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@：%@",self.source,self.titleStr] descr:@"" thumImage:[UIImage imageNamed:@"shareInfo"]];
        }
        else
        {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:[NSString stringWithFormat:@"%@%@：%@",self.addr,self.source,self.titleStr] descr:@"" thumImage:[UIImage imageNamed:@"shareInfo"]];
        }
        
    }
    else
    {
        if ([self.addr isEqualToString:@"中央部委"]) {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleStr descr:[NSString stringWithFormat:@"%@   %@",self.source,self.pubtime] thumImage:[UIImage imageNamed:@"shareInfo"]];
        }
        else
        {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:self.titleStr descr:[NSString stringWithFormat:@"%@%@   %@",self.addr,self.source,self.pubtime] thumImage:[UIImage imageNamed:@"shareInfo"]];
        }
        
    }
    //    设置网页地址·
    shareObject.webpageUrl =[[self.htmlUrl stringByAppendingString:@"&share=1" ]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    //    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //    //如果有缩略图，则设置缩略图
    //    shareObject.thumbImage = [UIImage imageNamed:@"logoImage"];
    //    [shareObject setShareImage:[self getTableViewimage]];
    
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
            [NetPromptBox showWithInfo:@"分享成功" stayTime:2];
        }
    }];
}

- (void)shareWithUrl:(NSString *)url subtitle:(NSString *)subtitle
{
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        
        [self shareWithType:platformType url:url subtitle:subtitle];
    }];
}

- (void)shareWithType:(UMSocialPlatformType)platformType url:(NSString *)url subtitle:(NSString *)subtitle
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"专利排行榜" descr:self.titleStr thumImage:[UIImage imageNamed:@"paihang"]];
    //    设置网页地址·
    shareObject.webpageUrl =url;
    
    
    //    UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
    //    //如果有缩略图，则设置缩略图
    //    shareObject.thumbImage = [UIImage imageNamed:@"logoImage"];
    //    [shareObject setShareImage:[self getTableViewimage]];
    
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************Share fail with error %@*********",error);
        }else{
            NSLog(@"response data is %@",data);
        }
    }];
}

- (void)cleanCacheAndCookie{
    NSSet *websiteDataTypes = [WKWebsiteDataStore allWebsiteDataTypes];
    
    //// Date from
    
    NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
    
    //// Execute
    
    [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
        
        // Done
        
    }];
}


@end
