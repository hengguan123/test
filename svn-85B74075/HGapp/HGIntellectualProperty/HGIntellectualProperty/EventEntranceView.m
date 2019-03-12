
//
//  EventEntranceView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/3/13.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "EventEntranceView.h"

#define EntranceViewWidth 40
#define EntranceViewHeight 40
@implementation EventEntranceView
static EventEntranceView *_view;

+(EventEntranceView *)share
{
    static dispatch_once_t EventEntranceViewonceToken;
    dispatch_once(&EventEntranceViewonceToken, ^{
        _view = [[EventEntranceView alloc]initWithFrame:CGRectMake(ScreenWidth-50, ScreenHeight-200, EntranceViewWidth, EntranceViewHeight)];
//        _view.backgroundColor = UIColorFromRGBA(0xfe6246, 0.5);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:_view.bounds];
        imageView.image = [UIImage imageNamed:@"活动"];
        [_view addSubview:imageView];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:_view action:@selector(panAct:)];
        [_view addGestureRecognizer:pan];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:_view action:@selector(tapAct:)];
        [_view addGestureRecognizer:tap];
    });
    return _view;
}

-(void)show
{
    [MyApp.window addSubview:_view];
}

-(void)dismiss
{
    [_view removeFromSuperview];
}
- (void)panAct: (UIPanGestureRecognizer *)rec{
    
    CGPoint point = [rec translationInView:MyApp.window];
//    NSLog(@"%f,%f",point.x,point.y);
    CGFloat centerX = rec.view.center.x + point.x;
    CGFloat centerY = rec.view.center.y + point.y;
    if (centerX<EntranceViewWidth/2) {
        centerX=EntranceViewWidth/2;
    }
    else if (centerX>ScreenWidth-EntranceViewWidth/2)
    {
        centerX = ScreenWidth-EntranceViewWidth/2;
    }
    if (centerY<EntranceViewHeight/2) {
        centerY = EntranceViewHeight/2;
    }
    else if (centerY>ScreenHeight-EntranceViewHeight/2)
    {
        centerY = ScreenHeight-EntranceViewHeight/2;
    }
    rec.view.center = CGPointMake(centerX,centerY);
    [rec setTranslation:CGPointMake(0, 0) inView:MyApp.window];
}

-(void)tapAct:(UITapGestureRecognizer *)tap
{
    [[NSNotificationCenter defaultCenter]postNotificationName:EventEntranceTapNoti object:nil userInfo:nil];
}

@end
