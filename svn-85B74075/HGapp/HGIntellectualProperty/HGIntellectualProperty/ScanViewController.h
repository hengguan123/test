//
//  ScanViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/10.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController


@property(nonatomic,copy)void (^resultBlock)(NSString *uuid);

@property(nonatomic,assign,getter=isFromProgressList)BOOL fromProgressList;


@end

