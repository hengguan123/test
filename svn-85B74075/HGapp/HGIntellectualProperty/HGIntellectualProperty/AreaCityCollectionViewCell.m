//
//  AreaCityCollectionViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "AreaCityCollectionViewCell.h"

@interface AreaCityCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *cityLab;

@end
@implementation AreaCityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(AreaModel *)model
{
    _model = model;
    self.cityLab.text = model.addrName;
    
    if (model.isSelected) {
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = MainColor.CGColor;
        self.cityLab.textColor = [UIColor whiteColor];
        self.backgroundColor = MainColor;
        
    }
    else
    {
//        self.layer.borderWidth = 0;
        self.cityLab.textColor = UIColorFromRGB(0x666666);
        self.backgroundColor = UIColorFromRGB(0xf2f2f2);
    }
}

@end
