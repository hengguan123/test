//
//  ErrandTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/1.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "ErrandTableViewCell.h"

@interface ErrandTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *desLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *functionBtn;


@end

@implementation ErrandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)grabOrder:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(grabOrderWithErrandTableViewCell: sender:)]) {
        [self.delegate grabOrderWithErrandTableViewCell:self sender:sender];
    }
}

-(void)setModel:(ErrandModel *)model
{
    _model = model;
    self.priceLab.text = [NSString stringWithFormat:@"%@",model.price];
    
    self.addressLab.text = model.dwellAddrName;
    
    if ([model.time hasSuffix:@"小时前"]) {
        NSInteger numHours = [model.time integerValue];
        if (numHours>=24) {
            self.timeLab.text = [NSString stringWithFormat:@"%@发布",[model.createTime substringToIndex:10]];
        }
        else
        {
            self.timeLab.text = [NSString stringWithFormat:@"%@发布",model.time];
        }
    }
    else
    {
        self.timeLab.text = [NSString stringWithFormat:@"%@发布",model.time];

    }
    if ([model.isInside isEqualToString:@"1"]) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[@"[官方]" stringByAppendingString:model.errandTitle]];
        [attrStr addAttribute:NSForegroundColorAttributeName value:MainColor range: NSMakeRange(0, 4)];
        self.titleLab.attributedText = attrStr;
    }
    else
    {
        self.titleLab.text = model.errandTitle;
    }
    self.desLab.text = [NSString stringWithFormat:@"%@%@%@",model.domainName,model.errandTypeName,model.busiTypeName];
    
    if ([AppUserDefaults share].isLogin) {
        if ([model.usrId isEqualToNumber:AppUserDefaults.share.usrId]) {
            self.functionBtn.enabled = NO;
            self.functionBtn.backgroundColor = UIColorFromRGB(0xcccccc);
        }
        else
        {
            self.functionBtn.enabled = YES;
            self.functionBtn.backgroundColor = MainColor;
        }
    }
    else{
        self.functionBtn.enabled = YES;
        self.functionBtn.backgroundColor = MainColor;
    }
    
}

@end
