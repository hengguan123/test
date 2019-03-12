//
//  SyetemMessageTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SyetemMessageTableViewCell.h"

@interface SyetemMessageTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *readStatusImage;



@end

@implementation SyetemMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(SystemMessageModel *)model
{
    _model = model;
    self.titleLab.text = model.msgTitle;
    self.contentLab.text = model.msgContent;
    self.timeLab.text = model.createTime;
    if ([model.readStatus boolValue]) {
        self.readStatusImage.hidden = YES;
    }
    else
    {
        self.readStatusImage.hidden = NO;
    }
}





@end
