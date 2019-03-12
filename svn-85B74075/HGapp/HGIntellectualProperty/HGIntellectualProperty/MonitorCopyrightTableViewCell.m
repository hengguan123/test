//
//  MonitorCopyrightTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/26.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MonitorCopyrightTableViewCell.h"


@interface MonitorCopyrightTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *regIdLab;
@property (weak, nonatomic) IBOutlet UILabel *pubtimeLab;
@property (weak, nonatomic) IBOutlet UILabel *remarkLab;
@property (weak, nonatomic) IBOutlet UILabel *typeInfoLab;

@end

@implementation MonitorCopyrightTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(MonitorContentModel *)model
{
    _model = model;
    self.typeLab.text = [NSString stringWithFormat:@"类型 %@",model.ipc];
    self.titleLab.text = model.title;
    self.regIdLab.text = [NSString stringWithFormat:@"登记号:%@",model.uniquelyid];
    if ([model.busiType isEqualToString:@"YWLX01-05-01"]) {
        self.typeInfoLab.text = @"软件著作权";
    }
    else if ([model.busiType isEqualToString:@"YWLX01-05-02"])
    {
        self.typeInfoLab.text = @"作品著作权";
    }
    self.pubtimeLab.text = [NSString stringWithFormat:@"首次发布时间 %@",model.pbd];
    if (!model.remark) {
        self.remarkLab.text = @"暂无动态";
    }
    else
    {
        self.remarkLab.text = model.remark;
    }
    
}



@end
