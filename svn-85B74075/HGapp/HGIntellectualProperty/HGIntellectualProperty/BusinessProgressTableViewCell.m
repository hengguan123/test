//
//  BusinessProgressTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/5/9.
//  Copyright © 2018年 HG. All rights reserved.
//

#import "BusinessProgressTableViewCell.h"
@interface BusinessProgressTableViewCell ()
@property (weak, nonatomic) IBOutlet UIView *verticalLineVIew;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIImageView *dropImageView;

@end

@implementation BusinessProgressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(CRMOrderProcessModel *)model
{
    _model = model;
    
    self.contentLab.text = model.status_name;
    self.timeLab.text = model.create_Time;
}
-(void)setType:(BusinessProgressType)type
{
//    CGRect frame = self.verticalLineVIew.frame;
    _type = type;
    if (type == BusinessProgressTypeCurrent) {
        self.contentLab.textColor = UIColorFromRGB(0x333333);
        self.timeLab.textColor = UIColorFromRGB(0x333333);
        self.dropImageView.image = [UIImage imageNamed:@"Group"];
        self.verticalLineVIew.frame = CGRectMake(22, 19, 1, self.bounds.size.height-19);
    }
    else if (type == BusinessProgressTypeDefault){
        self.contentLab.textColor = UIColorFromRGB(0xA09F9F);
        self.timeLab.textColor = UIColorFromRGB(0xA09F9F);
        self.dropImageView.image = [UIImage imageNamed:@"Oval"];
        self.verticalLineVIew.frame = CGRectMake(22, 0, 1, self.bounds.size.height);
    }
    else if (type == BusinessProgressTypeFirst)
    {
        self.contentLab.textColor = UIColorFromRGB(0xA09F9F);
        self.timeLab.textColor = UIColorFromRGB(0xA09F9F);
        self.dropImageView.image = [UIImage imageNamed:@"Oval"];
        self.verticalLineVIew.frame = CGRectMake(22, 0, 1, 19);
    }
    else if (type == BusinessProgressTypeFirstAndCurrent)
    {
        self.contentLab.textColor = UIColorFromRGB(0x333333);
        self.timeLab.textColor = UIColorFromRGB(0x333333);
        self.dropImageView.image = [UIImage imageNamed:@"Group"];
        self.verticalLineVIew.frame = CGRectMake(22, 19, 1, 1);
    }
}


@end
