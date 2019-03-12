//
//  PayMentTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/14.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PayMentTableViewCell.h"

@interface PayMentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLab;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@end

@implementation PayMentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setFrame:(CGRect)frame
{
    frame.size.height-=10;
    [super setFrame:frame];
}
-(void)setModel:(OrderModel *)model
{
    _model = model;
    self.priceLab.text = [NSString stringWithFormat:@"%@",model.orderPrice];
    self.titleLab.text = model.title;
    self.orderNumLab.text = [NSString stringWithFormat:@"订单号:%@",model.orderNo];
    self.timeLab.text = model.createTime;
}
- (IBAction)pay:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(payWithPayMentTableViewCell:)]) {
        [self.delegate payWithPayMentTableViewCell:self];
    }
    
}

-(void)setPayHidden:(BOOL)payHidden
{
    if (payHidden) {
        self.payBtn.hidden = YES;
    }
}

@end
