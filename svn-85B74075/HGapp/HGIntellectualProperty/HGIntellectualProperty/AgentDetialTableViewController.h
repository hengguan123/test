//
//  AgentDetialTableViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentDetialTableViewController : UITableViewController

@property(nonatomic,strong)NSNumber *usrId;
@property(nonatomic,assign,getter=isReduce)BOOL reduce;

@end
