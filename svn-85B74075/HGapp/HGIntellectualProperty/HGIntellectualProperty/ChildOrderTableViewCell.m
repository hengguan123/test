//
//  ChildOrderTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ChildOrderTableViewCell.h"

@interface ChildOrderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *typeImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end

@implementation ChildOrderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(ChildOrderModel *)model
{
    _model = model;
    self.typeImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@-拷贝",model.type]];
    self.titleLab.text = model.goodsName;
    self.orderNumLab.text = [NSString stringWithFormat:@"订单号:%@",model.orderNo];
    self.priceLab.text = [NSString stringWithFormat:@"%@元",model.goodsPrice];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
