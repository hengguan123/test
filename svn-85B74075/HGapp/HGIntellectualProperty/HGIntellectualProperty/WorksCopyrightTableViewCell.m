//
//  WorksCopyrightTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "WorksCopyrightTableViewCell.h"

@interface WorksCopyrightTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *owerLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *numLab;

@end

@implementation WorksCopyrightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(WorksCopyrightModel *)model
{
    _model = model;
    self.nameLab.text = model.name;
    self.owerLab.text = model.owner;
    self.timeLab.text = model.date;
    self.numLab.text = model.number;
}

@end
