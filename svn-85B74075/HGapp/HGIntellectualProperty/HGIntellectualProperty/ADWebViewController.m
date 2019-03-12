//
//  ADWebViewController.m
//  BBLive
//
//  Created by 车互帮 on 2016/11/25.
//  Copyright © 2016年 车互帮. All rights reserved.
//

#import "ADWebViewController.h"

@interface ADWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ADWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [LoadingManager show];
//    if (self.model.title) {
//        self.navigationItem.title=self.model.title;
//    }
//    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.model.linkUrl]]];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [LoadingManager dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if (error.code==-999) {
        
    }
    else
    {
        [SVProgressHUD showErrorWithStatus:error.domain];
        NSLog(@"%@",error);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated
{
    [LoadingManager dismiss];
}


@end
