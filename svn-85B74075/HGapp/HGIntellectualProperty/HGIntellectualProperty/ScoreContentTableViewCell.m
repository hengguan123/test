//
//  ScoreContentTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ScoreContentTableViewCell.h"

@interface ScoreContentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

@end

@implementation ScoreContentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;
    self.contentLab.text  = contentStr;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
