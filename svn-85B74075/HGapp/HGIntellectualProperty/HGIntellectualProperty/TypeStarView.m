//
//  TypeStarView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "TypeStarView.h"

@implementation TypeStarView
{
    UILabel *_titleLab;
    UIView *_starBgView;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _titleLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 6, frame.size.width, 12)];
        _titleLab.textAlignment = 1;
        _titleLab.font = [UIFont systemFontOfSize:12];
        [self addSubview:_titleLab];
        _starBgView = [[UIView alloc]initWithFrame:CGRectMake((frame.size.width-60)/2, 25, 60, 10    )];
        [self addSubview:_starBgView];
    }
    return self;
}
-(void)setModel:(ErrandClassModel *)model
{
    _model = model;
    UIImage *img;
    if (![model.delFlag boolValue]) {
        img = [UIImage imageNamed:@"btn_sel"];
        if ([model.starService isEqualToString:@""]) {
            [self setStarWithNum:0];
        }
        else{
            NSString *starNum = [model.starService substringFromIndex:model.starService.length-1];
            [self setStarWithNum:[starNum intValue]];
        }
        
    }
    else
    {
        img = [UIImage imageNamed:@"btn_nor"];
        [self setStarWithNum:0];
    }
    NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
    textAttach.image = img;
    NSAttributedString * strA =[NSAttributedString attributedStringWithAttachment:textAttach];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",model.dictionaryName]];
    
    [attri insertAttributedString:strA atIndex:0];
    _titleLab.attributedText = attri;
    
}

-(void)setStarWithNum:(int)num
{
    for (UIView *view in _starBgView.subviews) {
        [view removeFromSuperview];
    }
    for (int i= 0; i<5; i++) {
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(12*i, 0, 12, 10)];
        if (i<num) {
            [image setImage:[UIImage imageNamed:@"small_star_sel"]];
        }
        else
        {
            [image setImage:[UIImage imageNamed:@"small_star_nor"]];
        }
        image.contentMode = UIViewContentModeCenter;
        [_starBgView addSubview:image];
    }
}

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    UIImage *img;
    if (selected) {
        img = [UIImage imageNamed:@"btn_sel"];
    }
    else
    {
        img = [UIImage imageNamed:@"btn_nor"];
    }
    NSTextAttachment *textAttach = [[NSTextAttachment alloc]init];
    textAttach.image = img;
    NSAttributedString * strA =[NSAttributedString attributedStringWithAttachment:textAttach];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",self.model.dictionaryName]];
    [attri insertAttributedString:strA atIndex:0];
    _titleLab.attributedText = attri;
}

-(void)setTap:(BOOL)tap
{
    if (tap) {
        self.backgroundColor =UIColorFromRGBA(0xfeebe7, 1);
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = MainColor.CGColor;
    }
    else
    {
//        self.layer.borderWidth = 0;
        self.backgroundColor = UIColorFromRGB(0xffffff);
    }
}

@end
