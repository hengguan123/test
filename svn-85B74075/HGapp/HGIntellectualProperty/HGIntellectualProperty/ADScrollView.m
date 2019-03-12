//
//  ADScrollView.m
//  Star
//
//  Created by GJ on 16/3/23.
//  Copyright © 2016年 GJ. All rights reserved.
//

#import "ADScrollView.h"
#import "BannerUIImageView.h"

#define ADWidth _frame.size.width
#define ADHeight _frame.size.height


@implementation ADScrollView
{
    UIScrollView *_scrollView;
    UIPageControl *_page;
    NSTimer *_timer;
    int _listPage;
    int _currentPage;
    CGRect _frame;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        _frame = frame;
    }
    return self;
}

-(void)setImageArray:(NSArray *)imageArray
{
    if (_timer) {
        [_timer invalidate];
        _timer=nil;

    }
    _imageArray=imageArray;
    _scrollView=[[UIScrollView alloc]initWithFrame:self.bounds];
    _scrollView.backgroundColor=[UIColor grayColor];
    _scrollView.contentSize=CGSizeMake(ADWidth*(imageArray.count+2), 0);
    _scrollView.bounces=NO;
    _scrollView.pagingEnabled=YES;
    if (imageArray.count==1)
    {
        _scrollView.scrollEnabled=NO;
    }
    _scrollView.scrollEnabled=YES;
    _scrollView.delegate=self;
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    _scrollView.userInteractionEnabled=YES;
    CGFloat pageControlWide=20*imageArray.count;
    [self addSubview:_scrollView];
    _page=[[UIPageControl alloc]initWithFrame:CGRectMake((ADWidth-pageControlWide)/2, CGRectGetMaxY(_scrollView.frame)-60, pageControlWide, 20)];
//    _page.backgroundColor = [UIColor yellowColor];
    _page.numberOfPages=imageArray.count;
    _page.pageIndicatorTintColor=[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _page.currentPageIndicatorTintColor=UIColorFromRGB(0xffffff);
    [_page addTarget:self action:@selector(pageChange) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_page];
    //第一张图
    BannerUIImageView *image=[[BannerUIImageView alloc]initWithFrame:CGRectMake(0, 0, ADWidth,  ADHeight)];
    [image sd_setImageWithURL:[NSURL URLWithString:((BannerModel *)[imageArray lastObject]).url]];
    image.contentMode = UIViewContentModeScaleToFill;
    image.tag = 0;
    [_scrollView addSubview:image];
    image.model=[imageArray lastObject];
    //中间图
    for (int i=0; i<imageArray.count; i++)
    {
        BannerUIImageView *image=[[BannerUIImageView alloc]initWithFrame:CGRectMake(ADWidth*(i+1), 0, ADWidth,  ADHeight)];
        [image sd_setImageWithURL:[NSURL URLWithString:((BannerModel *)[imageArray objectAtIndex:i]).url]];
        [_scrollView addSubview:image];
        image.tag = i+1;
        image.contentMode = UIViewContentModeScaleToFill;
        image.model=[imageArray objectAtIndex:i];
//        UIButton *btn=[[UIButton alloc]initWithFrame:image.bounds];
//        [image addSubview:btn];
//        btn.backgroundColor=[UIColor redColor];
//        [btn addTarget:self action:@selector(imageTap) forControlEvents:UIControlEventTouchUpInside];
        image.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageTap)];
        [image addGestureRecognizer:tap];
        
    }//最后图
    BannerUIImageView *imagel=[[BannerUIImageView alloc]initWithFrame:CGRectMake(ADWidth*(imageArray.count+1), 0, ADWidth,  ADHeight)];
    imagel.model=[imageArray firstObject];
    [imagel sd_setImageWithURL:[NSURL URLWithString:((BannerModel *)[imageArray firstObject]).url]];
    imagel.tag = imageArray.count+1;
    [_scrollView addSubview:imagel];
    imagel.contentMode = UIViewContentModeScaleToFill;
    _scrollView.contentOffset=CGPointMake(ADWidth, 0);
 
    _currentPage=1;
    if (imageArray.count>1) {
        [self addTimer];
    }
}
-(void)imageTap
{
//    NSLog(@"%d",_currentPage);
    if ([self.delegate respondsToSelector:@selector(adScrollView:didSelectedBannerWith:)])
    {
        [self.delegate adScrollView:self didSelectedBannerWith:[_imageArray objectAtIndex:_currentPage-1]];
    }
}
-(void)pageChange
{
//    NSLog(@"--------%ld", _page.currentPage);
    [_scrollView setContentOffset:CGPointMake(ADWidth*(_page.currentPage+1), 0) animated:YES];
}

-(void)addTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer=[NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(scrollDragByTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)removeTimer
{
    [_timer invalidate];//当定时器停止时，本定时器就不会在工作，手动销毁
    _timer=nil;
}
-(void)scrollDragByTimer
{
    _currentPage++;
    BOOL is=NO;
    if ((long)_currentPage==_imageArray.count+1)
    {
        _currentPage=1;
        is=YES;
    }
    if (is)
    {
        [_scrollView setContentOffset:CGPointMake(ADWidth*(_imageArray.count+1), 0) animated:YES];
    }else
    {
        [_scrollView setContentOffset:CGPointMake(ADWidth*_currentPage, 0) animated:YES];
    }
//    NSLog(@"%d",_currentPage);
}
#pragma mark --- UIScrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    NSLog(@"移动的坐标:%f,%f",scrollView.contentOffset.x,scrollView.contentOffset.y);
    if (scrollView==_scrollView)
    {
        NSInteger index=(scrollView.contentOffset.x+ADWidth/2.0)/ADWidth;
        //设置当前的点,用来指示当前页面
        _page.currentPage=index-1;
        if (scrollView.contentOffset.x==ADWidth*(_imageArray.count+1))
        {
            [_scrollView setContentOffset:CGPointMake(ADWidth, 0) animated:NO];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView==_scrollView)
    {
        if (scrollView.contentOffset.x/ADWidth==_imageArray.count+1)
        {
            _scrollView.contentOffset=CGPointMake(ADWidth, 0);
        }
        else if(scrollView.contentOffset.x/ADWidth==0)
        {
            _scrollView.contentOffset=CGPointMake(ADWidth*_imageArray.count, 0);
        }
        _currentPage=scrollView.contentOffset.x/ADWidth;
    }
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeTimer];
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addTimer];
}
-(void)setFrame:(CGRect)frame
{
//    NSLog(@"XXX:%f----YYY%f,%f-----%f",frame.origin.x,frame.origin.y,frame.size.width,frame.size.height);
    if (frame.size.width>ScreenWidth) {
        [self removeTimer];
    }
    [super setFrame:frame];
    _frame = frame;
    _scrollView.frame = frame;
    _page.frame = CGRectMake(_page.frame.origin.x, frame.size.height-60, _page.frame.size.width, _page.frame.size.height);
    _scrollView.contentOffset = CGPointMake(ADWidth*_currentPage, 0);
//    _scrollView.contentSize=CGSizeMake(ADWidth*(self.imageArray.count+2), 0);
    
    for (UIView *view in _scrollView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            view.frame = CGRectMake(ADWidth*view.tag, 0, ADWidth, ADHeight);
        }
    }
    if (frame.size.width == ScreenWidth) {
        [self addTimer];
    }
}

@end
