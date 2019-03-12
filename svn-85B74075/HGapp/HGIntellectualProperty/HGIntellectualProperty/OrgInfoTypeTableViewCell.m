//
//  OrgInfoTypeTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/17.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "OrgInfoTypeTableViewCell.h"

@interface OrgInfoTypeTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) UIView *newView;
@end

@implementation OrgInfoTypeTableViewCell
{
    CGFloat _width;
}
- (void)awakeFromNib {
    [super awakeFromNib];
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
        CGSize size = [orgmodel.departName boundingRectWithSize:CGSizeMake(MAXFLOAT, 22) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        _width = size.width;
    }
}

-(void)setAreamodel:(OrgAreaModel *)areamodel
{
    _areamodel = areamodel;
    self.nameLab.text = areamodel.addrName;
}

-(void)setIsSel:(BOOL)isSel
{
    _isSel = isSel;
    if (isSel) {
        self.nameLab.textColor = MainColor;
    }
    else
    {
        self.nameLab.textColor = UIColorFromRGB(0x666666);
    }
}

-(void)setIsNew:(BOOL)isNew
{
    if (isNew) {
        [self.contentView addSubview:self.newView];
        self.newView.frame = CGRectMake(_width+15, 18, 8, 8);
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
@end
