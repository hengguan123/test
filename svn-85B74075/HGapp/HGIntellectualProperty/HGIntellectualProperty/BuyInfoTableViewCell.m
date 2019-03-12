//
//  BuyInfoTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/25.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "BuyInfoTableViewCell.h"
@interface BuyInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation BuyInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(BuyInformationModel *)model
{
    _model = model;
    self.nameLab.text = model.businessName;
    self.timeLab.text = [NSString stringWithFormat:@"发布时间: %@",model.createTime];
}

@end
