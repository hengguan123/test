//
//  MyGrapTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "MyGrapTableViewCell.h"


@interface MyGrapTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *classDesLab;
@property (weak, nonatomic) IBOutlet UIButton *functionBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *stustasLab;

@end
@implementation MyGrapTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setType:(ErrandTableViewCellType)type
{
    _type = type;
    if (type == ErrandTableViewCellTypeMyGrap) {
        if ([self.model.errandStatus isEqualToString:@"CSZT01-02"]||[self.model.errandStatus isEqualToString:@"CSZT01-06"]||[self.model.errandStatus isEqualToString:@"CSZT01-07"]) {
            [self.functionBtn setTitle:@"办理进度" forState:UIControlStateNormal];
        }
        else
        {
             [self.functionBtn setTitle:@"办理" forState:UIControlStateNormal];
        }
    }
    else if (type == ErrandTableViewCellTypeToCommented)
    {
        [self.functionBtn setTitle:@"评价" forState:UIControlStateNormal];

    }
    else if (type == ErrandTableViewCellStyleToPay)
    {
        [self.functionBtn setTitle:@"去支付" forState:UIControlStateNormal];
    }
    
}

-(void)setModel:(ErrandModel *)model
{
    _model = model;
    self.titleLab.text = model.errandTitle;
    self.classDesLab.text = [NSString stringWithFormat:@"%@%@%@",model.domainName,model.errandTypeName,model.busiTypeName];
    if ([model.provinceName isEqualToString:model.dwellAddrName]) {
        self.addressLab.text = model.dwellAddrName;
    }
    else
    {
        self.addressLab.text = [NSString stringWithFormat:@"%@%@",model.provinceName,model.dwellAddrName];
    }
    self.stustasLab.text = model.errandStatusName;
    self.priceLab.text = [NSString stringWithFormat:@"%@",model.price];
    if (self.type == ErrandTableViewCellTypeMyGrap) {
        if ([self.model.errandStatus isEqualToString:@"CSZT01-02"]||[self.model.errandStatus isEqualToString:@"CSZT01-06"]||[self.model.errandStatus isEqualToString:@"CSZT01-07"]) {
            [self.functionBtn setTitle:@"办理进度" forState:UIControlStateNormal];
        }
        else
        {
            [self.functionBtn setTitle:@"办理" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)functionClick:(id)sender {
    if (self.type == ErrandTableViewCellTypeToCommented) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(writeReviewTableViewCell:)]) {
            [self.delegate writeReviewTableViewCell:self];
        }
    }
    else if (self.type == ErrandTableViewCellTypeMyGrap)
    {
        if ([self.model.errandStatus isEqualToString:@"CSZT01-02"]||[self.model.errandStatus isEqualToString:@"CSZT01-06"]||[self.model.errandStatus isEqualToString:@"CSZT01-07"]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(lookProgressTableViewCell:)]) {
                [self.delegate lookProgressTableViewCell:self];
            }
        }
        else
        {
            if (self.delegate && [self.delegate respondsToSelector:@selector(addProgressTableViewCell:)]) {
                [self.delegate addProgressTableViewCell:self];
            }
        }
        
    }
    else if (self.type ==ErrandTableViewCellStyleToPay)
    {
        NSLog(@"去支付");
        if (self.delegate&&[self.delegate respondsToSelector:@selector(payTableViewCell:)]) {
            [self.delegate payTableViewCell:self];
        }
    }
}

@end
