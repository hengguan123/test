//
//  AgentTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AgentTableViewCell.h"

@interface AgentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UILabel *typeLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIView *starBgView;

@end

@implementation AgentTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(AgentModel *)model
{
    _model = model;
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@%@",model.facilitatorName,model.provinceName,model.cityName]];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0f] range:NSMakeRange(0, model.facilitatorName.length)];
    //添加文字颜色
    [attrStr addAttribute:NSForegroundColorAttributeName value:MainColor range:NSMakeRange(0, model.facilitatorName.length)];
    self.nameLab.attributedText = attrStr;
    NSMutableArray *typeStrArr = [NSMutableArray new];
//    NSInteger x= MIN(3, model.queryListClassify.count);
    for (NSInteger i=0; i<model.queryListClassify.count; i++) {
        AgentDomainModel *domodel = [model.queryListClassify objectAtIndex:i];
        [typeStrArr addObject:domodel.classifyName];
    }
    self.typeLab.text = [typeStrArr componentsJoinedByString:@" | "];
    
    NSString *star = [model.starService substringFromIndex:model.starService.length-1];
    [self setStarWithNum:[star integerValue]];
    self.priceLab.text = [NSString stringWithFormat:@"%@元",model.unitPrice];
}

-(void)setStarWithNum:(NSInteger)star
{
    for (UIView *view in self.starBgView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            UIImageView *imageView = (UIImageView *)view;
            if (imageView.tag<star) {
                imageView.image = [UIImage imageNamed:@"agentstar_sel"];
            }
            else
            {
                imageView.image = [UIImage imageNamed:@"agentstar_nor"];
            }
        }
    }
}

- (IBAction)functionClick:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(phoneWithAgentTableViewCell:)]) {
        [self.delegate phoneWithAgentTableViewCell:self];
    }
    
}



@end
