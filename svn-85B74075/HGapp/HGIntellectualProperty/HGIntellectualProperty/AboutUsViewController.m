//
//  AboutUsViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AboutUsViewController.h"
#import "RequestURL.h"
@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)phone:(id)sender {
    NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4001830900"];
    // NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (IBAction)serviceTerms:(id)sender {
    WebViewController *vc = [[WebViewController alloc]init];
    vc.titleStr = @"服务条款";
    vc.urlStr = [NSString stringWithFormat:@"%@%@",HTTPURL,@"/faci/userAgree"];
    
    [self.navigationController pushViewController:vc animated:YES];
}



@end
