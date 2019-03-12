//
//  CityCollectionViewCell.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/6.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "CityCollectionViewCell.h"

@interface CityCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *cityName;

@end

@implementation CityCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cityName.layer.borderColor = UIColorFromRGBA(0x666666, 0.3).CGColor;
    self.cityName.layer.borderWidth = 0.5;
}

-(void)setCityModel:(AreaModel *)cityModel
{
    _cityModel = cityModel;
    self.cityName.text = cityModel.addrName;
    if (cityModel.isSelected) {
        self.cityName.backgroundColor = MainColor;
        self.cityName.textColor = [UIColor whiteColor];
    }
    else
    {
        self.cityName.backgroundColor
        = [UIColor whiteColor];
        self.cityName.textColor = UIColorFromRGB(0x2B3C4E);
    }
}
-(void)setFilterModel:(FilterTypeModel *)filterModel
{
    _filterModel = filterModel;
    self.cityName.text = filterModel.name;
    if (filterModel.isSel) {
        self.cityName.backgroundColor = MainColor;
        self.cityName.textColor = [UIColor whiteColor];
    }
    else
    {
        self.cityName.backgroundColor
        = [UIColor whiteColor];
        self.cityName.textColor = UIColorFromRGB(0x2B3C4E);
    }
}


@end
