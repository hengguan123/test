//
//  BusinessDetailTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/4/27.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "BusinessDetailTableViewCell.h"

@interface BusinessDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *typeImageView;

@end

@implementation BusinessDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(ChildOrderModel *)model
{
    _model = model;
    self.nameLab.text = model.goodsName;
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",model.goodsPrice];
    self.typeImageView.image = [UIImage imageNamed:model.type];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
