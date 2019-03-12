//
//  HTMLViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/11.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HTMLViewController : UIViewController

@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *htmlUrl;
@property(nonatomic,assign)BOOL rightItem;
@property(nonatomic,assign)BOOL canShare;
@property(nonatomic,assign)BOOL naviHidden;
@property(nonatomic,copy)NSString *physicDb;

@property(nonatomic,copy)NSString *addr;
@property(nonatomic,copy)NSString *source;
@property(nonatomic,copy)NSString *pubtime;

@end
