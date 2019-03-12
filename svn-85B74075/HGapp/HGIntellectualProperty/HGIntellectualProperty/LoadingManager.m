//
//  LoadingManager.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/21.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "LoadingManager.h"

@implementation LoadingManager

+(void)show
{
    [MyApp.window addSubview:[self loadingImageView]];
    [UIView animateWithDuration:0.2 animations:^{
        [self loadingImageView].alpha = 1.0;
    }];
}

+(UIImageView *)loadingImageView
{
    static dispatch_once_t loadingViewOnce;
    static UIImageView *loadingView;
    dispatch_once(&loadingViewOnce, ^{
        loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        loadingView.center = MyApp.window.center;
        loadingView.backgroundColor = [UIColor clearColor];
        loadingView.contentMode = UIViewContentModeCenter;
        loadingView.alpha = 0.0;
        
        
        [loadingView setImage:[UIImage imageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"123456789" ofType:@"gif"]]]];
    });
    
    return loadingView;
}
+(void)dismiss
{
    [UIView animateWithDuration:0.2 animations:^{
        [self loadingImageView].alpha = 0.0;
    } completion:^(BOOL finished) {
        [[self loadingImageView]removeFromSuperview];
    }];
}
@end
