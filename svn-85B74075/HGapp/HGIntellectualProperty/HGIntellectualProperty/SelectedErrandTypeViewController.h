//
//  SelectedErrandTypeViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "RootViewController.h"

@interface SelectedErrandTypeViewController : RootViewController

@property(nonatomic,copy)void(^block)(ErrandClassModel *model);

@end
