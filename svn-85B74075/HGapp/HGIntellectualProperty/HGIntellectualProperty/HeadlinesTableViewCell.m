//
//  HeadlinesTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/6.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "HeadlinesTableViewCell.h"

@interface HeadlinesTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *source;
@property (weak, nonatomic) IBOutlet UILabel *addrLab;


@end

@implementation HeadlinesTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(HeadlinesModel *)model
{
    _model = model;
    self.titleLab.text = model.title;
    self.timeLab.text = model.pubDate ;
    self.source.text = [model.addr stringByAppendingString: model.source];
//    self.addrLab.text = model.addr;
}

@end
