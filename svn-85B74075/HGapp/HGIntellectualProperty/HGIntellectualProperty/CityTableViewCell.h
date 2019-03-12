//
//  CityTableViewCell.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityTableViewCell;
@protocol CityTableViewCellDelegate <NSObject>

-(void)cityTableViewCell:(CityTableViewCell *)cityTableViewCell didSelectedItemWithCityModel:(AreaModel *)cityModel;

@end


@interface CityTableViewCell : UITableViewCell

@property(nonatomic,strong)NSArray *cityArray;

@property(nonatomic,strong)id<CityTableViewCellDelegate>delegate;

@end
