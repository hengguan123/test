//
//  BusinessDetailHeaderTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/4/27.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "BusinessDetailHeaderTableViewCell.h"

@interface BusinessDetailHeaderTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderNoLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

@end

@implementation BusinessDetailHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setModel:(OrderModel *)model
{
    _model = model;
    self.orderNoLab.text = model.orderNo;
    self.timeLab.text = model.createTime;
    self.priceLab.text = [NSString stringWithFormat:@"￥%@",model.orderPrice];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
