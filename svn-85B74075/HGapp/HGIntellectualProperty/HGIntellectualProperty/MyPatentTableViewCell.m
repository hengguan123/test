//
//  MyPatentTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MyPatentTableViewCell.h"

@interface MyPatentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *IDLab;
@property (weak, nonatomic) IBOutlet UILabel *personLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;

@end

@implementation MyPatentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(MyPatentModel *)model
{
    _model = model;
    self.statusLab.text = [NSString stringWithFormat:@"状态:%@",model.pkind];
    self.nameLab.text = [NSString stringWithFormat:@"名称:%@",model.patentName];
    self.IDLab.text = [NSString stringWithFormat:@"公开号:%@",model.patentPn];
    self.personLab.text = [NSString stringWithFormat:@"专利权人:%@",model.company];
}


@end
