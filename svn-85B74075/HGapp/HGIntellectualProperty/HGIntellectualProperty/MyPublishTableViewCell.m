//
//  MyPublishTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MyPublishTableViewCell.h"

@interface MyPublishTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *scheduleLab;
@property (weak, nonatomic) IBOutlet UIImageView *publishIcon;
@property (weak, nonatomic) IBOutlet UILabel *publishTimeLab;
@property (weak, nonatomic) IBOutlet UIImageView *addressIcon;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *functionBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;



@end

@implementation MyPublishTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setFrame:(CGRect)frame
{
    frame.size.height -= 10;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(ErrandModel *)model
{
    _model = model;
    if ([model.isRobOrder boolValue]) {
        self.publishIcon.hidden = YES;
        self.publishTimeLab.hidden = YES;
        self.scheduleLab.hidden = NO;
        self.deleteBtn.hidden = YES;
        [self.functionBtn setTitle:@"查看进度" forState:UIControlStateNormal];
        self.scheduleLab.text = model.errandStatusName;
        
    }
    else
    {
        self.publishIcon.hidden = NO;
        self.publishTimeLab.hidden = NO;
        self.scheduleLab.hidden = YES;
        self.deleteBtn.hidden = NO;
        [self.functionBtn setTitle:@"修改" forState:UIControlStateNormal];
        if ([model.time hasSuffix:@"小时前"]) {
            NSInteger numHours = [model.time integerValue];
            if (numHours>=24) {
                self.publishTimeLab.text = [NSString stringWithFormat:@"%@发布",[model.createTime substringToIndex:10]];
            }
            else
            {
                self.publishTimeLab.text = [NSString stringWithFormat:@"%@发布",model.time];
            }
        }
        else
        {
            self.publishTimeLab.text = [NSString stringWithFormat:@"%@发布",model.time];
            
        }
    }
    self.addressLab.text = model.dwellAddrName;
    self.priceLab.text = [NSString stringWithFormat:@"%@",model.price];
    if ([model.isInside isEqualToString:@"1"]) {
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[@"[官方]" stringByAppendingString:model.errandTitle]];
        [attrStr addAttribute:NSForegroundColorAttributeName value:MainColor range: NSMakeRange(0, 4)];
        self.titleLab.attributedText = attrStr;
    }
    else
    {
        self.titleLab.text = model.errandTitle;
    }
    self.typeLab.text = [NSString stringWithFormat:@"%@%@%@",model.domainName,model.errandTypeName,model.busiTypeName];
    
}

- (IBAction)functionBtnClick:(id)sender {
    if ([self.model.isRobOrder boolValue]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(lookoverProgressPublishTableViewCell:)]) {
            [self.delegate lookoverProgressPublishTableViewCell:self];
        }
    }
    else
    {
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeErrandMyPublishTableViewCell:)]) {
            [self.delegate changeErrandMyPublishTableViewCell:self];
        }
    }
}

- (IBAction)deleteBtnClick:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteErrandMyPublishTableViewCell:)]) {
        [self.delegate deleteErrandMyPublishTableViewCell:self];
    }
}


@end
