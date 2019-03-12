//
//  OtherWorkTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/30.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "OtherWorkTableViewCell.h"

@interface OtherWorkTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIView *selColorView;
@end

@implementation OtherWorkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setOtherModel:(OtherWorkModel *)otherModel
{
    _otherModel = otherModel;
    self.nameLab.text = otherModel.dictionaryName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.selColorView.hidden = NO;
        self.nameLab.textColor = MainColor;
    }
    else
    {
        self.selColorView.hidden = YES;
        self.nameLab.textColor = UIColorFromRGB(0x666666);
    }
    
}
@end
