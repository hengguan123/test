//
//  ResultNumView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ResultNumView.h"

@implementation ResultNumView

-(instancetype)initWithNum:(NSNumber *)num
{
    CGRect frame = CGRectMake(0, 0, ScreenWidth, 34);
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20, 33)];
        lab.backgroundColor = [UIColor whiteColor];
        lab.textColor = UIColorFromRGB(0x666666);
        lab.font = [UIFont systemFontOfSize:12];
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"共搜索到%@个对象",num]];
        
        // 添加文字颜色
        [attri addAttribute:NSForegroundColorAttributeName
                        value:MainColor
                        range:NSMakeRange(4, attri.length-7)];
        lab.attributedText = attri;
        [self addSubview:lab];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 33, ScreenWidth, 0.5)];
        line.backgroundColor = UIColorFromRGB(0xf2f2f2);
        [self addSubview:line];
    }
    return self;
}

@end
