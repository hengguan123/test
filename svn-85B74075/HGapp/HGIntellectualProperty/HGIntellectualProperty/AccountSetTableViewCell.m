//
//  AccountSetTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/1/31.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "AccountSetTableViewCell.h"

@interface AccountSetTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *lab;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@end

@implementation AccountSetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.bindBtn setTitle:@"已绑定" forState:UIControlStateSelected | UIControlStateHighlighted];
    [self.bindBtn setTitleColor:UIColorFromRGB(0xB2B2B2) forState:UIControlStateSelected | UIControlStateHighlighted ];
    [self.bindBtn setTitleColor:UIColorFromRGB(0x2F83FA) forState:UIControlStateNormal | UIControlStateHighlighted ];
    [self.bindBtn setTitle:@"绑 定" forState:UIControlStateNormal | UIControlStateHighlighted];
}

-(void)setIndex:(NSInteger)index
{
    _index= index;
    if (index == 0) {
        self.lab.text = @"登录手机号";
        self.imgView.image = [UIImage imageNamed:@"icon_phone"];
    }
    else if (index == 1)
    {
        self.lab.text = @"微信";
        self.imgView.image = [UIImage imageNamed:@"icon_wx"];
    }
    else if (index == 2)
    {
        self.lab.text = @"QQ";
        self.imgView.image = [UIImage imageNamed:@"icon_QQ"];
    }
}

-(void)setSel:(BOOL)sel
{
    _sel = sel;
    self.bindBtn.selected = sel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)bindClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(btnClickAccountSetTableViewCell:)]) {
        [self.delegate btnClickAccountSetTableViewCell:self];
    }
}

@end
