//
//  ShoppingTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/17.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ShoppingTableViewCell.h"

@interface ShoppingTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *selBtn;
@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;


@end

@implementation ShoppingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(NoPayModel *)model
{
    _model = model;
    self.typeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-拷贝",model.type]];
    self.titleLab.text = model.goodsName;
    self.typeLab.text = [model.businessTypeName stringByAppendingString:model.classifyName];
    self.priceLab.text = [NSString stringWithFormat:@"%ld元",[model.price integerValue]];
    self.selBtn.selected = model.isSelected;
}

- (IBAction)selected:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    self.model.selected = sender.selected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tapSelBtnShoppingTableViewCell:)]) {
        [self.delegate tapSelBtnShoppingTableViewCell:self];
    }
}


@end
