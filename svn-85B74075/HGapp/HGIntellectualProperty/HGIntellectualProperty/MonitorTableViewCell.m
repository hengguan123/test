//
//  MonitorTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/10.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MonitorTableViewCell.h"

@interface MonitorTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;

@property (weak, nonatomic) IBOutlet UILabel *patentDevelopmentLab;
@property (weak, nonatomic) IBOutlet UILabel *trademarkDevelopmentLab;
@property (weak, nonatomic) IBOutlet UILabel *copyrightDevelopmentLab;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation MonitorTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(MonitorCompanyModel *)model
{
    _model = model;
    self.nameLab.text = model.companyName;
    self.addressLab.text = [NSString stringWithFormat:@"地址:%@",model.address];
    NSArray *array = [model.remark componentsSeparatedByString:@"，"];
    self.patentDevelopmentLab.text = [array firstObject];
    if (array.count >=2) {
        self.trademarkDevelopmentLab.text = [array objectAtIndex:1];
    }
    if (array.count==3) {
        self.copyrightDevelopmentLab.text = [array lastObject];

    }
    self.patentDevelopmentLab.text = model.remark;
    self.trademarkDevelopmentLab.text = model.remark;
    self.copyrightDevelopmentLab.text = model.remark;
    if ([model.monitorStatus boolValue]) {
        self.btn.selected = YES;
        [self.btn setBackgroundColor:[UIColor whiteColor]];
    }
    else if ([model.monitorStatus boolValue])
    {
        self.btn.selected = NO;
        self.btn.backgroundColor = MainColor;
    }
}

- (IBAction)btnClick:(UIButton *)sender {
    sender.selected = !sender.isSelected;
    
    if (sender.isSelected) {
        sender.backgroundColor = [UIColor whiteColor];
        
        [RequestManager cancelDeleteMonitorWithMonitorId:self.model.monitorId successHandler:^(BOOL success) {
            
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        sender.backgroundColor =MainColor;
        [RequestManager deleteMonitorWithMonitorId:self.model.monitorId successHandler:^(BOOL success) {
            
        } errorHandler:^(NSError *error) {
            
        }];
    }
}


@end
