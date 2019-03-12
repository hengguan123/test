//
//  OrderInfoTableViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderInfoTableViewController : UITableViewController

@property(nonatomic,strong)OrderModel *model;
@property(nonatomic,assign)BOOL payStatus;
@property(nonatomic,strong)UIViewController *fromList;


@end
