//
//  AttentionTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/11/2.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AttentionTableViewCell.h"
@interface AttentionTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIButton *careBtn;
@property (weak, nonatomic) IBOutlet UIView *redDot;

@end

@implementation AttentionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(AttentionModel *)model{
    _model = model;
    NSString *info = [NSString stringWithFormat:@"%@%@",model.addrName,model.departName];
    self.contentLab.text = info;
    self.careBtn.selected = model.isSel;
    if ([model.flag isEqualToString:@"0"]) {
        self.redDot.hidden = NO;
        CGSize size = [info boundingRectWithSize:CGSizeMake(MAXFLOAT, 22) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        CGRect frame = self.redDot.frame;
        frame.origin.x = size.width +20;
        self.redDot.frame = frame;
    }
    else
    {
        self.redDot.hidden = YES;
    }
    
    
}
- (IBAction)care:(UIButton *)sender {
    [LoadingManager show];
    if (sender.isSelected) {
        [RequestManager addAttentionWithAddrCode:self.model.addrCode addrName:self.model.addrName departName:self.model.departName departCode:self.model.departCode SuccessHandler:^(NSNumber *modelId) {
            self.model.modelId = modelId;
            sender.selected = NO;
            [LoadingManager dismiss];
        } errorHandler:^(NSError *error) {
            
        }];
    }
    else
    {
        [RequestManager deleteAttentionWithId:self.model.modelId SuccessHandler:^(BOOL success) {
            sender.selected = YES;
            [LoadingManager dismiss];
        } errorHandler:^(NSError *error) {
            
        }];
    }
    
    
}

@end
