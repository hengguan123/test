//
//  PatentProgressTableViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/31.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "PatentProgressTableViewCell.h"

@interface PatentProgressTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *timeLab;
@property (weak, nonatomic) IBOutlet UILabel *infoLab;

@property (nonatomic,strong) NSArray *colorArray;
@property (weak, nonatomic) IBOutlet UILabel *fileTypeLab;

@end

@implementation PatentProgressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(NSArray *)colorArray
{
    if (!_colorArray) {
        _colorArray = @[UIColorFromRGB(0x8aafb2),UIColorFromRGB(0x83b152),UIColorFromRGB(0x9a5187),UIColorFromRGB(0xecab1d),UIColorFromRGB(0x0087ae),UIColorFromRGB(0x009086)];
    }
    return _colorArray;
}

-(void)setIndex:(NSInteger)index
{
    _index = index;
//    self.colorView.backgroundColor = [self.colorArray objectAtIndex:index%6];
}

-(void)setModel:(PatentProgressModel *)model
{
    _model = model;
    if ([model.fileName isEqualToString:@"1"] ) {
        self.infoLab.text = @"授权通知书";
    }
    else
    {
        self.infoLab.text = model.fileName;
    }
    self.timeLab.text = model.pubDate;
    self.fileTypeLab.text = [model.receivedWay stringByAppendingString:model.eleParts];
}

@end
