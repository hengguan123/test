//
//  UIBarButtonItem+GGExtension.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/25.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "UIBarButtonItem+GGExtension.h"

@implementation UIBarButtonItem (GGExtension)

-(UIBarButtonItem *)initWithTitle:(NSString *)title font:(CGFloat)fontSize target:(id)target action:(SEL)action
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:target action:action];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName, nil] forState:UIControlStateNormal];
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:13],NSFontAttributeName, nil] forState:UIControlStateHighlighted];
    return item;
}

@end
