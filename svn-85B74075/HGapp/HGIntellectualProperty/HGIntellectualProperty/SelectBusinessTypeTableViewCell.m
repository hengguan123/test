//
//  SelectBusinessTypeTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/23.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SelectBusinessTypeTableViewCell.h"

@interface SelectBusinessTypeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *selBtn;

@end
@implementation SelectBusinessTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setModel:(ErrandClassModel *)model
{
    _model = model;
    self.content.text = model.dictionaryName;
    self.selBtn.selected = ![model.delFlag boolValue];
}



@end
