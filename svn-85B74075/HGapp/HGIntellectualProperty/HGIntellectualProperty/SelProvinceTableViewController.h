//
//  SelProvinceTableViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelProvinceTableViewController : UITableViewController
@property(nonatomic,copy)void(^block)(AreaModel *cityModel);

@end
