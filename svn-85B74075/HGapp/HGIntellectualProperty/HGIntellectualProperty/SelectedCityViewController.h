//
//  SelectedCityViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "RootViewController.h"

@interface SelectedCityViewController : RootViewController

@property(nonatomic,copy)NSString *currentCity;
@property(nonatomic,copy)void(^block)(AreaModel *cityModel);

@end
