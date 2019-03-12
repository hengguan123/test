//
//  ProgressTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ProgressTableViewCell.h"

@interface ProgressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLab;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLab;

@end

@implementation ProgressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(ProgressModel *)model
{
    self.statusLab.text = model.errandStatusName;
    self.createTimeLab.text = model.createTime;
    self.endTimeLab.text = [model.endTime substringToIndex:10];
    self.remarkLab.text = model.remark;
}

@end
