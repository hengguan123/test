//
//  PayViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/22.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : UIViewController

@property(nonatomic,strong)OrderModel *model;
@property(nonatomic,strong)UIViewController *fromList;
@property(nonatomic,copy)NSString *isInside;


@end
