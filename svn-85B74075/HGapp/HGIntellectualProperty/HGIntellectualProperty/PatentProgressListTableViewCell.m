//
//  PatentProgressListTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/11.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PatentProgressListTableViewCell.h"

@interface PatentProgressListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *applicantLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *applyNo;
@property (weak, nonatomic) IBOutlet UILabel *applyDate;

@property (weak, nonatomic) IBOutlet UIImageView *patentImageView;


@end

@implementation PatentProgressListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(CompanyEnableProgressPatentModel *)model
{
    _model = model;
    self.titleLab.text = model.patentName;
    self.applicantLab.text = [NSString stringWithFormat:@"申请人：%@",model.applyPerson];
    self.typeLab.text = [NSString stringWithFormat:@"类型：%@",model.caseType];
    self.applyNo.text = [NSString stringWithFormat:@"申请号：%@",model.applyNo];
    self.applyDate.text = [NSString stringWithFormat:@"申请日期：%@",model.applyDate];
    [self.patentImageView sd_setImageWithURL:[NSURL URLWithString:ImageURL(model.insetUrl)] placeholderImage:[UIImage imageNamed:@"loadbad"]];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
