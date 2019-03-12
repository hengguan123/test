//
//  ScrollInfoTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ScrollInfoTableViewCell.h"
@interface ScrollInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end
@implementation ScrollInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(BuyInformationModel *)model
{
    NSString *price = model.price;
    if (model.price==nil || [model.price isEqualToString:@""]) {
        price = @"暂无";
    }
    
    self.titleLab.text = [NSString stringWithFormat:@"%@ (报价:%@)",model.businessName,price];
    if (model.createTime.length>=11) {
        self.timeLab.text = [model.createTime substringToIndex:11];
    }
    else
    {
        self.timeLab.text = model.createTime ;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
