//
//  NoPayInfoTableViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoPayInfoTableViewController : UITableViewController

@property(nonatomic,strong)OrderModel *model;
/// 支付状态 NO 未支付   YES 已支付
@property(nonatomic,assign)BOOL payStatus;
@property(nonatomic,strong)UIViewController *fromList;

@end
