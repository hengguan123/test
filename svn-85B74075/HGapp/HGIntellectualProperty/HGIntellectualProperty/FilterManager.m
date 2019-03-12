//
//  FilterManager.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "FilterManager.h"
#define SingleApp ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface FilterManager ()

@property(nonatomic,strong)UIWindow *filterWindow;
@property(nonatomic,strong)UIView *filterBgView;

@end

@implementation FilterManager
{
    UIViewController *_filterVc;
    
}


-(instancetype)initWithFilterVc:(UIViewController *)filterVc
{
    if (self = [super init]) {
        _filterVc = filterVc;
    }
    return self;
}
-(UIWindow *)filterWindow
{
    if (!_filterWindow) {
        _filterWindow = [[UIWindow alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        
        _filterWindow.windowLevel = UIWindowLevelNormal;
        _filterWindow.hidden = NO;
        [_filterWindow makeKeyAndVisible];
        _filterWindow.backgroundColor = UIColorFromRGBA(0xffffff, 0);
        
        _filterWindow.rootViewController = _filterVc;
    }
    return _filterWindow;
}

-(UIView *)filterBgView
{
    if (!_filterBgView) {
        _filterBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _filterBgView.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        _filterBgView.alpha = 0;
    }
    return _filterBgView;
}

-(void)show
{
    [SingleApp.window addSubview:self.filterBgView];
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 1;
        self.filterWindow.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    }];
}

-(void)hidden
{
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 0;
        self.filterWindow.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.filterBgView removeFromSuperview];
        [self.filterWindow resignKeyWindow];
    }];
}


-(void)sureCompletion:(void (^)(BOOL))completion
{
    [UIView animateWithDuration:0.5 animations:^{
        self.filterBgView.alpha = 0;
        self.filterWindow.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight);
    } completion:^(BOOL finished) {
        [self.filterBgView removeFromSuperview];
        [self.filterWindow resignKeyWindow];
        completion(finished);
    }];

}


@end
