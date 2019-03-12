//
//  CALayer+StoryBoardConfig.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/9.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CALayer+StoryBoardConfig.h"

@implementation CALayer (StoryBoardConfig)

-(void)setBorderUIColor:(UIColor *)borderUIColor
{
    self.borderColor = borderUIColor.CGColor;
}
-(UIColor *)borderUIColor
{
    return [UIColor colorWithCGColor:self.borderColor];
}

@end
