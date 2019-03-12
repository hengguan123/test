//
//  TrademarkTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "TrademarkTableViewCell.h"

@interface TrademarkTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *logo;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *classLab;
@property (weak, nonatomic) IBOutlet UILabel *statusLab;
@property (weak, nonatomic) IBOutlet UILabel *NumLab;
@property (weak, nonatomic) IBOutlet UILabel *changeLab;
@property (weak, nonatomic) IBOutlet UILabel *tagLab;
@property (weak, nonatomic) IBOutlet UILabel *applyLab;

@end

@implementation TrademarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(TrademarkModel *)model
{
    _model = model;
    if ([model.tmImg hasPrefix:@"http://"]) {
        [self.logo sd_setImageWithURL:[NSURL URLWithString:model.tmImg] placeholderImage:nil];
    }
    else
    {
        [self.logo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://tmpic.tmkoo.com/%@-m",model.tmImg]] placeholderImage:nil];
    }
    if (self.searchStr) {
        if ([model.tmName containsString:self.searchStr]) {
            NSMutableAttributedString * anAttrStr = [[NSMutableAttributedString alloc]initWithString:model.tmName];
            [anAttrStr
             addAttribute:NSForegroundColorAttributeName value:MainColor range:[model.tmName rangeOfString:self.searchStr]];
            self.nameLab.attributedText = anAttrStr;
        }
        else
        {
            self.nameLab.text= model.tmName;
        }
        if ([model.applicantCn containsString:self.searchStr]) {
            
            NSString *str = [NSString stringWithFormat:@"申请人:%@",model.applicantCn];
            NSMutableAttributedString * anAttrStr = [[NSMutableAttributedString alloc]initWithString:str];
            [anAttrStr
             addAttribute:NSForegroundColorAttributeName value:MainColor range:[str rangeOfString:self.searchStr]];
            self.applyLab.attributedText = anAttrStr;
        }
        else
        {
            self.applyLab.text = [NSString stringWithFormat:@"申请人:%@",model.applicantCn];
        }
    }
    else
    {
        self.nameLab.text= model.tmName;
        self.applyLab.text = [NSString stringWithFormat:@"申请人:%@",model.applicantCn];
    }
    self.classLab.text = [NSString stringWithFormat:@"商标类型:第%@类 %@",model.intCls,[[AppUserDefaults share].trademarkType objectForKey:model.intCls]];
    self.statusLab.text = model.currentStatus;
    self.NumLab.text = [NSString stringWithFormat:@"注册号:%@  申请时间:%@",model.regNo,model.appDate];
    
}

-(void)setMoniModel:(MonitorContentModel *)moniModel
{
    _moniModel = moniModel;
    [self.logo sd_setImageWithURL:[NSURL URLWithString:moniModel.imgUrl] placeholderImage:nil];
    self.nameLab.text= moniModel.title;
    
    self.classLab.text = [NSString stringWithFormat:@"商标类型:第%@类 %@",moniModel.ipc,[[AppUserDefaults share].trademarkType objectForKey:moniModel.ipc]];
    self.statusLab.text = [NSString stringWithFormat:@"状态:%@",moniModel.nwLegal];
    self.NumLab.text = [NSString stringWithFormat:@"注册号:%@  申请时间:%@",moniModel.uniquelyid,moniModel.pbd];
    if (moniModel.remark==nil||[moniModel.remark isEqualToString:@""]) {
        self.changeLab.text = @"暂无动态";
    }
    else
    {
        self.changeLab.text = moniModel.remark;
    }
    
}

-(void)setHiddenTag:(BOOL)hiddenTag
{
    _hiddenTag = hiddenTag;
    self.tagLab.hidden = hiddenTag;
}

@end
