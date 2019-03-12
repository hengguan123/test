//
//  NetPromptBox.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/5/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "NetPromptBox.h"


@implementation NetPromptBox

static NetPromptBox *_netPromptBox;

+(NetPromptBox *)share
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _netPromptBox = [[NetPromptBox alloc]init];
        [MyApp.window  addSubview:_netPromptBox];
    });
    return _netPromptBox;
}

+(void)showWithInfo:(NSString *)info stayTime:(NSInteger)time
{
    NetPromptBox *promptBox = [NetPromptBox share];
    promptBox.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    promptBox.frame = CGRectMake((ScreenWidth-200)/2, ScreenHeight-200, 200, 30);
    promptBox.layer.cornerRadius = 15;
    promptBox.layer.masksToBounds = YES;
    promptBox.textAlignment = 1;
    promptBox.textColor = [UIColor whiteColor];
    promptBox.alpha = 0;
    if (info) {
        promptBox.text = info;
        [UIView animateWithDuration:0.5 animations:^{
            promptBox.alpha = 1;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 delay:time options:UIViewAnimationOptionTransitionNone animations:^{
                promptBox.alpha = 0;
            } completion:nil];
        }];
    }
}

@end
