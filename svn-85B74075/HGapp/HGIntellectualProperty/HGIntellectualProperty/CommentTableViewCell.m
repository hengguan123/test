//
//  CommentTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CommentTableViewCell.h"

@interface CommentTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UILabel *classLab;

@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (weak, nonatomic) IBOutlet UIImageView *star1;
@property (weak, nonatomic) IBOutlet UIImageView *star2;
@property (weak, nonatomic) IBOutlet UIImageView *star3;
@property (weak, nonatomic) IBOutlet UIImageView *star4;
@property (weak, nonatomic) IBOutlet UIImageView *star5;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@end

@implementation CommentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(CommentModel *)model
{
    _model = model;
    if (model.portraitUrl==nil || [model.portraitUrl isEqualToString:@""]) {
        [self.userImageView setImage:[UIImage imageNamed:@"关于我们" ]];
    }
    else
    {
        [self.userImageView sd_setImageWithURL:[NSURL URLWithString:ImageURL(model.portraitUrl)]];
    }
    self.nickNameLab.text = model.usrAlias;[NSString stringWithFormat:@"%@ %@%@%@ (%@)",model.usrAlias,model.domainName,model.errandTypeName,model.busiTypeName,model.cityName];
    self.classLab.text = [NSString stringWithFormat:@"%@%@%@",model.domainName,model.errandTypeName,model.busiTypeName];
    if ([model.provinceName isEqualToString:model.cityName]) {
        self.addressLab.text = model.provinceName;
    }
    else
    {
        self.addressLab.text = [NSString stringWithFormat:@"%@%@",model.provinceName,model.cityName];
    }
    if ([model.evalContent isEqualToString:@""]) {
        self.contentLab.text = @"无评价内容";
    }
    else
    {
        self.contentLab.text = model.evalContent;
    }
    [self starWithNum:[model.evalLevel intValue]];
    self.timeLab.text = [model.createTime substringToIndex:10];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)starWithNum:(int)num
{
    int starNum = MIN(5, num);
    switch (starNum) {
        case 1:
        {
            self.star1.image = [UIImage imageNamed:@"star_sel"];
            self.star2.image = [UIImage imageNamed:@"star_nor"];
            self.star3.image = [UIImage imageNamed:@"star_nor"];
            self.star4.image = [UIImage imageNamed:@"star_nor"];
            self.star5.image = [UIImage imageNamed:@"star_nor"];
            
        }
            break;
        case 2:
        {
            self.star1.image = [UIImage imageNamed:@"star_sel"];
            self.star2.image = [UIImage imageNamed:@"star_sel"];
            self.star3.image = [UIImage imageNamed:@"star_nor"];
            self.star4.image = [UIImage imageNamed:@"star_nor"];
            self.star5.image = [UIImage imageNamed:@"star_nor"];
            
        }
            break;
        case 3:
        {
            self.star1.image = [UIImage imageNamed:@"star_sel"];
            self.star2.image = [UIImage imageNamed:@"star_sel"];
            self.star3.image = [UIImage imageNamed:@"star_sel"];
            self.star4.image = [UIImage imageNamed:@"star_nor"];
            self.star5.image = [UIImage imageNamed:@"star_nor"];
            
        }
            break;
        case 4:
        {
            self.star1.image = [UIImage imageNamed:@"star_sel"];
            self.star2.image = [UIImage imageNamed:@"star_sel"];
            self.star3.image = [UIImage imageNamed:@"star_sel"];
            self.star4.image = [UIImage imageNamed:@"star_sel"];
            self.star5.image = [UIImage imageNamed:@"star_nor"];
            
        }
            break;
        case 5:
        {
            self.star1.image = [UIImage imageNamed:@"star_sel"];
            self.star2.image = [UIImage imageNamed:@"star_sel"];
            self.star3.image = [UIImage imageNamed:@"star_sel"];
            self.star4.image = [UIImage imageNamed:@"star_sel"];
            self.star5.image = [UIImage imageNamed:@"star_sel"];
            
        }
            break;
        default:
            break;
    }
}
@end
