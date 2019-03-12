//
//  ErrandsDetialTableViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ErrandModel.h"

@interface ErrandsDetialTableViewController : UITableViewController

@property(nonatomic,strong)ErrandModel *model;
@property(nonatomic,strong)UIViewController *fromList;


@end
