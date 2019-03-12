//
//  PreviewViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/28.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PreviewViewController.h"
#import <Quicklook/Quicklook.h>

@interface PreviewViewController ()<QLPreviewControllerDataSource,QLPreviewControllerDelegate>
@property(nonatomic,strong)  QLPreviewController  *previewController;

@end

@implementation PreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"附件详情";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back_icon"] style:UIBarButtonItemStyleDone target:self action:@selector(back)];
    self.view.backgroundColor = UIColorFromRGB(0xf2f2f2);
    
    self.previewController = [[QLPreviewController alloc] init]; /** 这里我们要使用QLPreviewController的代理方法 */
    self.previewController.dataSource = self;
    self.previewController.delegate = self;
    self.previewController.view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64); /** 这里需要注意的是，我们不使用Controller，而是使用Controller的View，为的是避免QLController在Navgation等Controller中带来的坑 */
    [self addChildViewController:self.previewController];
    [self.view addSubview:self.previewController.view];
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (NSInteger)numberOfPreviewItemsInPreviewController:(nonnull QLPreviewController *)controller {
    return 1;
}

- (nonnull id<QLPreviewItem>)previewController:(nonnull QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return [NSURL fileURLWithPath:self.path];
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller {
    NSLog(@"预览界面已经消失");
}
//文件内部链接点击不进行外部跳转
- (BOOL)previewController:(QLPreviewController *)controller shouldOpenURL:(NSURL *)url forPreviewItem:(id <QLPreviewItem>)item
{
    return NO;
}

@end
