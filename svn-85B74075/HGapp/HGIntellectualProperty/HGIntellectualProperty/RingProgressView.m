//
//  RingProgressView.m
//  Demo
//
//  Created by 耿广杰 on 2017/8/18.
//  Copyright © 2017年 GG. All rights reserved.
//

#import "RingProgressView.h"

#define PI 3.14159265358979323846

@interface RingProgressView ()

@property(nonatomic,assign)CGFloat endAngle;
@property(nonatomic,assign)NSInteger num;

@end

@implementation RingProgressView

-(void)drawRect:(CGRect)rect
{
    // Drawing code
    CGFloat bgeAngle = 270+self.endAngle;
    CGFloat centerX = CGRectGetWidth(rect)/2.0;
    CGFloat centerY = CGRectGetHeight(rect)/2.0;
    CGFloat radius = 30;
    CGFloat lineWidth = 10;
    //一个不透明类型的Quartz 2D绘画环境,相当于一个画布,你可以在上面任意绘画
    CGContextRef context = UIGraphicsGetCurrentContext();
    /*画圆*/
    
//    圆1  背景圆
    UIColor *bColor = _foregroundColor;
    CGContextSetStrokeColorWithColor(context, bColor.CGColor);  //画笔线的颜色
    CGContextSetLineWidth(context, lineWidth);//线的宽度
    CGContextAddArc(context, centerX, centerY, radius, 0, 2*PI, NO);      // 添加一个圆
    CGContextDrawPath(context, kCGPathStroke);

//    圆2  进度圆
    
    //边框圆 -- 底色
    UIColor *aColor = _ringColor;
    CGContextSetStrokeColorWithColor(context, aColor.CGColor);  //画笔线的颜色
    CGContextSetLineWidth(context, lineWidth);//线的宽度
    CGContextAddArc(context, centerX, centerY, radius, PI*3/2,2*PI*(bgeAngle/360), NO);      // 添加一个圆
    CGContextDrawPath(context, kCGPathStroke);              // 绘制路径
}

-(void)setProgress:(CGFloat )progress
{
    if (progress > 1.0) {
        progress = 1.0;
    }
    
    self.num = progress*360;
    
}

-(void)setNum:(NSInteger)num
{
    if (_num==0) {
        _num = num;
        [NSThread detachNewThreadSelector:@selector(doSomething) toTarget:self withObject:nil];
    }
}

-(void)doSomething
{
//    NSLog(@"%-------ld",self.num);
    
    CGFloat time = 1.0/self.num;
    self.endAngle = 0;
    [self updateUI];
    for (int i=0; i<self.num; i++) {
        self.endAngle = 0-i;
        
//        NSLog(@"%@结束：%f-----i=%d",self.model.title,self.endAngle,i);
        [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:NO];
        [NSThread sleepForTimeInterval:time];
    }
    _num = 0;
}



//更新UI
- (void)updateUI {
    [self setNeedsDisplay];
}

@end
