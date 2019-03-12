//
//  OrganizationTypeTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/30.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "OrganizationTypeTableViewCell.h"

@interface OrganizationTypeTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;

@property (strong, nonatomic) UIView *newView;


@end

@implementation OrganizationTypeTableViewCell
{
    CGFloat _width;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setOrgmodel:(OrganizationModel *)orgmodel
{
    _orgmodel = orgmodel;
    if (orgmodel.dictionaryName) {
        self.nameLab.text = orgmodel.dictionaryName;
        
    }
    else if(orgmodel.departName)
    {
        self.nameLab.text = orgmodel.departName;
        
        
    }
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize size = [self.orgmodel.departName boundingRectWithSize:CGSizeMake(MAXFLOAT, self.bounds.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    _width = MIN(size.width, self.nameLab.bounds.size.width);
    self.newView.frame = CGRectMake(_width+15, 18, 8, 8);

}
-(void)setIsSel:(BOOL)isSel{
    _isSel = isSel;
    if (isSel) {
        self.nameLab.textColor = MainColor;
        
    }
    else
    {
        self.nameLab.textColor = UIColorFromRGB(0x666666);
        
    }}
-(void)setIsNew:(BOOL)isNew{
    if (isNew) {
        [self.contentView addSubview:self.newView];
    }
    else
    {
        [self.newView removeFromSuperview];
        
    }
}

-(UIView *)newView
{
    if (!_newView) {
        _newView = [[UIView alloc]initWithFrame:CGRectMake(0, 18, 8, 8)];
        _newView.backgroundColor = [UIColor redColor];
        _newView.layer.cornerRadius = 4;
        
    }
    return _newView;
}
- (IBAction)attention:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(organizationTypeTableViewCell:beFollowedWithBtnSelected:)]) {
        [self.delegate organizationTypeTableViewCell:self beFollowedWithBtnSelected:sender.selected];
    }
}

-(void)setIsAttention:(BOOL)isAttention
{
    _isAttention = isAttention;
    self.careBtn.selected = isAttention;
}

@end
