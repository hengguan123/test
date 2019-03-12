//
//  OtherMergeViewController.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "OtherMergeViewController.h"
#import "OtherProfessionalWorkViewController.h"
#import "ErrandsListTableViewController.h"
#import "ErrandFilterViewController.h"

@interface OtherMergeViewController ()
@property (weak, nonatomic) IBOutlet UIButton *FindErrandBtn;
@property (weak, nonatomic) IBOutlet UIButton *goPublicErrandBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic,strong)UIBarButtonItem *rightItem;

@property (nonatomic,strong) UIView *filterBgView;
@property (nonatomic,strong) UIWindow *filterWindow;
@property (nonatomic,strong) ErrandFilterViewController *filterVC;
@property (nonatomic,strong) ErrandsListTableViewController *errandVC;
@property (nonatomic,strong) OtherProfessionalWorkViewController *otherVC;
@end

@implementation OtherMergeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*2, 0);
    
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _errandVC = [mainStory instantiateViewControllerWithIdentifier:@"ErrandsListTableViewController"];
    [self addChildViewController:_errandVC];
    _errandVC.view.frame = self.scrollView.bounds;
    [self.scrollView addSubview:_errandVC.view];
    
    _otherVC = [mainStory instantiateViewControllerWithIdentifier:@"OtherProfessionalWorkViewController"];
    [self addChildViewController:_otherVC];
    _otherVC.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollView.bounds.size.height);
    [self.scrollView addSubview:_otherVC.view];
    
}

-(UIBarButtonItem *)rightItem
{
    if (!_rightItem) {
        _rightItem = [[UIBarButtonItem alloc]initWithTitle:@"筛选" font:13 target:self action:@selector(filter)];
    }
    return _rightItem;
}

-(void)filter
{
    [MyApp.window addSubview:self.filterBgView];
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 1;
        self.filterWindow.frame = CGRectMake(100, 0, ScreenWidth-100, ScreenHeight);
    }];
}
-(UIView *)filterBgView
{
    if (!_filterBgView) {
        _filterBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _filterBgView.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        _filterBgView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(filterBgViewTab)];
        [_filterBgView addGestureRecognizer:tap];
        
    }
    return _filterBgView;
}
-(UIWindow *)filterWindow
{
    if (!_filterWindow) {
        _filterWindow = [[UIWindow alloc]initWithFrame:CGRectMake(100+ScreenWidth, 0, ScreenWidth-100, ScreenHeight)];
        
        _filterWindow.windowLevel = UIWindowLevelNormal;
        _filterWindow.hidden = NO;
        [_filterWindow makeKeyAndVisible];
        _filterWindow.backgroundColor = [UIColor whiteColor];
        
        _filterWindow.rootViewController = self.filterVC;
    }
    return _filterWindow;
}
-(ErrandFilterViewController *)filterVC
{
    if (!_filterVC) {
        _filterVC = [[ErrandFilterViewController alloc]init];
        _filterVC.view.frame = CGRectMake(0, 0, ScreenWidth-100, ScreenHeight);
        __weak typeof(self) weakSelf = self;
        
        _filterVC.selectItemsBlock = ^(NSString *addrStr, NSString *typeLikeStr, NSString *subTpeyStr) {
            [weakSelf.errandVC filterSelAddr:addrStr typeStrLike:typeLikeStr busiType:subTpeyStr];
            [weakSelf finishLoadData];
        };
        
    }
    return _filterVC;
}

-(void)finishLoadData
{
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 0;
        self.filterWindow.frame = CGRectMake(ScreenWidth+100, 0, ScreenWidth-100, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.filterBgView removeFromSuperview];
        [self.filterWindow resignKeyWindow];
        self.filterWindow = nil;
//        [self loadListRefresh:YES];
        
    }];
}

-(void)filterBgViewTab
{
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 0;
        self.filterWindow.frame = CGRectMake(ScreenWidth+100, 0, ScreenWidth-100, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.filterBgView removeFromSuperview];
        [self.filterWindow resignKeyWindow];
        self.filterWindow = nil;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)btnClick:(UIButton *)sender {
    sender.selected = YES;
    [UIView animateWithDuration:0.3 animations:^{
        self.lineView.center = CGPointMake(sender.center.x, self.lineView.center.y);
    }];
    if (sender == self.FindErrandBtn) {
        self.goPublicErrandBtn.selected = NO;
        self.scrollView.contentOffset = CGPointMake(0, 0);
        self.navigationItem.rightBarButtonItem = self.rightItem;
    }
    else
    {
        self.FindErrandBtn.selected = NO;
        self.scrollView.contentOffset = CGPointMake(ScreenWidth, 0);
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


@end
