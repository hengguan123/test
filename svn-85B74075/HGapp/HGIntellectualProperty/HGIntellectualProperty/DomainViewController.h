//
//  DomainViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/21.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "RootViewController.h"

@interface DomainViewController : RootViewController

@property(nonatomic,copy)void(^block)(ErrandClassModel *model);

@end
