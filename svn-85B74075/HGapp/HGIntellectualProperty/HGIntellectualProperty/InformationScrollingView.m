//
//  InformationScrollingView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/24.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "InformationScrollingView.h"
#import "InfoScrollTableView.h"
@implementation InformationScrollingView
{
    UIScrollView *_scrollView;
    InfoScrollTableView *_tableView1;
    InfoScrollTableView *_tableView2;
    NSTimer *_timer;
    int index;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
//        _scrollView.backgroundColor = [UIColor yellowColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollEnabled = NO;
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        _scrollView.contentSize = CGSizeMake(0, frame.size.height*2);
        _tableView1 = [[InfoScrollTableView alloc]initWithFrame:CGRectMake(0, 5, frame.size.width, frame.size.height-10)];
//        _tableView1.backgroundColor = [UIColor redColor];
        [_scrollView addSubview:_tableView1];
        
        _tableView2 = [[InfoScrollTableView alloc]initWithFrame:CGRectMake(0, frame.size.height+5, frame.size.width, frame.size.height-10)];
//        _tableView2.backgroundColor = [UIColor blueColor];
        [_scrollView addSubview:_tableView2];
    }
    return self;
}

-(void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    index = 0;
    [self startTimer];
    
}

-(void)startTimer
{
    if (_timer) {
        _timer = nil;
        [_timer invalidate];
    }
    [self takeDataWithIndex:index];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)removeTimer
{
    _timer = nil;
    [_timer invalidate];
}
-(void)timerAction
{
//    NSLog(@"滚动");
    dispatch_async(dispatch_get_main_queue(), ^{
       [_scrollView setContentOffset:CGPointMake(0, self.bounds.size.height)animated:YES];
    });
    
}


-(void)takeDataWithIndex:(int)index
{
    [_scrollView setContentOffset:CGPointMake(0, 0)];
    _tableView1.dataArray = [self.dataArray objectsAtIndexes:[[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(index*2, 2)]];
    int nextIndex = index + 1;
    if (nextIndex >= self.dataArray.count/2) {
        nextIndex = 0;
    }
    _tableView2.dataArray = [self.dataArray objectsAtIndexes:[[NSIndexSet alloc]initWithIndexesInRange:NSMakeRange(nextIndex*2, 2)]];
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    index ++ ;
    if (index>=5) {
        index = 0;
    }
    [self takeDataWithIndex:index];
    
}
-(void)tap
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(taptap)]) {
        [self.delegate taptap];
    }
    NSLog(@"tap");
}

@end
