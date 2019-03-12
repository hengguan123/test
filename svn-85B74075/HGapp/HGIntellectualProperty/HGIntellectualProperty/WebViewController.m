//
//  WebViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/5/31.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "WebViewController.h"
#import "AgentViewController.h"
#import "PendingPaymentViewController.h"
#import "CompanyViewController.h"


@interface WebViewController ()<UIWebViewDelegate>
//@property (strong, nonatomic)WKWebView *webView;
@property(nonatomic,strong)UIWebView *web;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UIView setAnimationsEnabled:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.title = self.titleStr;
    _web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    _web.backgroundColor = [UIColor whiteColor];
    _web.delegate = self;
    //2.创建URL
    NSURL *URL = [NSURL URLWithString:[self.urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    //3.创建Request
    NSURLRequest *request = [NSURLRequest requestWithURL:URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:5];
    //4.加载Request
    [_web loadRequest:request];
    [LoadingManager show];
    [self.view addSubview:_web];
    
    [_web mas_makeConstraints:^(MASConstraintMaker *make) {
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
    
    
    if (self.sharePatent||self.shareTradeMark) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享" font:13 target:self action:@selector(share)];
        
    }
    
    
}

-(void)back
{
    if ([self.web canGoBack])
    {
        if ([self.web.request.URL.absoluteString containsString:self.urlStr]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [self.web goBack];
        }
    }else
    {
        [self.view resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [LoadingManager dismiss];
    NSLog(@"loading---%@",webView.request.URL.absoluteString);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error.userInfo);
    [webView reload];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *str = request.URL.absoluteString;
//    NSLog(@"%@",str);
    if ([str containsString:@"h5type"]) {
        
        [self handelWithUrlParameter:str];
        return NO;
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
    h5type
    0   未登录
    1   跳转代理人
    2   跳转购物车
    3   点击公司名
    4
    5   进度
    6   购买完成关闭当前
 
 */

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
    else if ([parameterArray.firstObject isEqualToString:@"h5type=2"]||[parameterArray.firstObject isEqualToString:@"h5type=4"])
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
        
    }else if ([parameterArray.firstObject isEqualToString:@"h5type=6"])
    {
        [NetPromptBox showWithInfo:@"提交成功" stayTime:2];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)share
{
    if (self.sharePatent) {
        NSArray *arr = [self.urlStr componentsSeparatedByString:@"&"];
        NSMutableString *url = [[NSMutableString alloc]initWithFormat:@"%@%@",HTTPURL,@"/patent/info?"];
        for (int i = 0; i<arr.count; i++) {
            
            if (i>0) {
                [url appendFormat:@"%@&",[arr objectAtIndex:i]];
            }
        }
        [url appendString:@"share=1"];
        [[ShareManager share]shareWithShareUrl:url title:self.shareTitile subTitle:self.shareSubTitile image:[UIImage imageNamed:@"PatentShare"]];
    }
    else if (self.shareTradeMark)
    {
        NSArray *array = [self.urlStr componentsSeparatedByString:@"&usrPhone"];
        
        NSMutableString *url = [[NSMutableString alloc]initWithString:array.firstObject];
        [url appendString:@"&share=1"];
        NSString *shareUrl = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [[ShareManager share]shareWithShareUrl:shareUrl title:self.shareTitile subTitle:self.shareSubTitile image:[UIImage imageNamed:@"trademarkShare"]];
    }
    
}

@end
