//
//  SoftwareCopyrightTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SoftwareCopyrightTableViewCell.h"

@interface SoftwareCopyrightTableViewCell();
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *numberLab;
@property (weak, nonatomic) IBOutlet UILabel *ownerLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *postLab;

@end

@implementation SoftwareCopyrightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(SoftwareCopyrightModel *)model
{
    _model = model;
    self.titleLab.text = model.name;
    self.numberLab.text = [NSString stringWithFormat:@"登记号:%@",model.number];
    self.ownerLab.text = [NSString stringWithFormat:@"拥有者:%@",model.owner];
    self.timeLab.text = model.recordDate;
    self.postLab.text = model.postDate;
}


@end
