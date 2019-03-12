//
//  CityCollectionViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/6.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterTypeModel.h"

@interface CityCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong)AreaModel *cityModel;
@property(nonatomic,strong)FilterTypeModel *filterModel;


@end
