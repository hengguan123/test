//
//  CitySectionHeaderView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CitySectionHeaderView.h"

@implementation CitySectionHeaderView
{
    UILabel *_provinceNameLab;
    UIImageView *_statusImageView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        _provinceNameLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-100, frame.size.height)];
        _provinceNameLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        _provinceNameLab.font = [UIFont systemFontOfSize:14];
        [self addSubview:_provinceNameLab];
        
        _statusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width-34, 0, 34, 34)];
        _statusImageView.image = [UIImage imageNamed:@"more_down"];
        _statusImageView.contentMode = UIViewContentModeCenter;
        
        [self addSubview:_statusImageView];
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, frame.size.height-0.5, ScreenWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:8/255.0 green:1/255.0 blue:3/255.0 alpha:0.3];
        [self addSubview:line];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}
- (void)setOpen:(BOOL)open
{
    _open = open;
    if (open) {
        _statusImageView.image = [UIImage imageNamed:@"more_up"];
    }
    else
    {
        _statusImageView.image = [UIImage imageNamed:@"more_down"];
    }
}

-(void)setProvinceName:(NSString *)provinceName
{
    _provinceName = provinceName;
    _provinceNameLab.text = provinceName;
}

- (void)tap:(UITapGestureRecognizer *)tap
{
//    self.open = !self.isOpen;
    if (self.delegate && [self.delegate respondsToSelector:@selector(openOrCloseCitySectionHeaderView:)]) {
        [self.delegate openOrCloseCitySectionHeaderView:self];
    }
}
@end
