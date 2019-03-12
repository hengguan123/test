//
//  RobbedDetialTableViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GrabDetialFunctionType) {
    GrabDetialFunctionTypeHandle=1,
    GrabDetialFunctionTypeComment=2,
    GrabDetialFunctionTypeProgress=3,
    GrabDetialFunctionTypePay=4,
};

@interface RobbedDetialTableViewController : UITableViewController

@property(nonatomic,assign)GrabDetialFunctionType type;
@property(nonatomic,strong)ErrandModel *model;
@property(nonatomic,strong)UIViewController *fromList;

@end
