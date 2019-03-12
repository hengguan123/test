//
//  SearchCompanyTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "SearchCompanyTableViewCell.h"

@interface SearchCompanyTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *companyNameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIButton *patentBtn;
@property (weak, nonatomic) IBOutlet UIButton *tradeMarkBtn;
@property (weak, nonatomic) IBOutlet UIButton *copyrightBtn;

@end
@implementation SearchCompanyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(SearchAllModel *)model
{
    _model = model;
    self.companyNameLab.text = model.companyName;
    
    self.addressLab.text = model.address;
    
    [self.patentBtn setTitle:[NSString stringWithFormat:@"专利%@项",model.patentNum] forState:UIControlStateNormal];
    [self.tradeMarkBtn setTitle:[NSString stringWithFormat:@"商标%@项",model.tradeNum] forState:UIControlStateNormal];
    [self.copyrightBtn setTitle:[NSString stringWithFormat:@"著作权%ld项",[model.copyrightNum integerValue]] forState:UIControlStateNormal];
}

- (IBAction)patentList:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(patentListWithSearchCompanyTableViewCell:)]) {
        [self.delegate patentListWithSearchCompanyTableViewCell:self];
    }
}
- (IBAction)trademarkList:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(trademarkListWithSearchCompanyTableViewCell:)]) {
        [self.delegate trademarkListWithSearchCompanyTableViewCell:self];
    }
}
- (IBAction)copyrightList:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(copyrightListWithSearchCompanyTableViewCell:)]) {
        [self.delegate copyrightListWithSearchCompanyTableViewCell:self];
    }
}



@end
