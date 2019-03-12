//
//  TypeReusableView.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/23.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "TypeReusableView.h"

@interface TypeReusableView()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end


@implementation TypeReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setTitle:(NSString *)title
{
    _title = title;
    self.lab.text = title;
}
@end
