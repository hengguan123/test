//
//  WebViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/5/31.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "RootViewController.h"

@interface WebViewController : RootViewController

@property(nonatomic,copy)NSString *urlStr;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,copy)NSString *physicDb;

@property(nonatomic,assign)BOOL sharePatent;
@property(nonatomic,assign)BOOL shareTradeMark;
@property(nonatomic,copy)NSString *shareTitile;
@property(nonatomic,copy)NSString *shareSubTitile;

@end
