//
//  RecordingTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "RecordingTableViewCell.h"

@interface RecordingTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *weekLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIView *typeView;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *detailTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property (weak, nonatomic) IBOutlet UILabel *realNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bankCordIdLab;

@end

@implementation RecordingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(RecordingModel *)model
{
    _model = model;
    self.moneyLab.text = [NSString stringWithFormat:@"%@元",model.optMoney];
    self.titleLab.text = model.optDesc;
    self.timeLab.text = [model.createTime substringToIndex:10];
    self.detailTimeLab.text = model.createTime;
    if ([model.optType intValue]==0) {
        self.typeView.backgroundColor =[UIColor colorWithHue:1.00 saturation:0.65 brightness:0.98 alpha:1.00];
        self.typeLab.text = @"收入";
        self.moneyLab.textColor =[UIColor colorWithHue:1.00 saturation:0.65 brightness:0.98 alpha:1.00];
        self.statusImageView.hidden = YES;
        self.realNameLab.hidden = YES;
        self.bankCordIdLab.hidden = YES;
    }
    else if ([model.optType intValue]==1)
    {
        self.typeView.backgroundColor = [UIColor colorWithHue:0.59 saturation:0.81 brightness:0.99 alpha:1.00];
        self.typeLab.text = @"提现";
        self.moneyLab.textColor= [UIColor colorWithHue:0.59 saturation:0.81 brightness:0.99 alpha:1.00];
        self.statusImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"recording%@",model.optStatus]];
        self.statusImageView.hidden = NO;
        self.realNameLab.hidden = NO;
        self.bankCordIdLab.hidden = NO;
        self.realNameLab.text =[NSString stringWithFormat:@"真实姓名：%@",model.usrRealName ];
        self.bankCordIdLab.text =[NSString stringWithFormat:@"银行账户：%@",model.bankCardNo ];
    }
    else if ([model.optType intValue]==2)
    {
        self.typeView.backgroundColor = [UIColor colorWithHue:0.41 saturation:0.68 brightness:0.69 alpha:1.00];
        self.typeLab.text = @"消费";
        self.moneyLab.textColor= [UIColor colorWithHue:0.41 saturation:0.68 brightness:0.69 alpha:1.00];
        self.statusImageView.hidden = YES;
        self.realNameLab.hidden = YES;
        self.bankCordIdLab.hidden = YES;
    }
    self.weekLab.text = model.week;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
