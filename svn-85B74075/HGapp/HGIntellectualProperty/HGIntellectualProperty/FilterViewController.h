//
//  FilterViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController

@property(nonatomic,copy)void(^selectItemBlock)(NSString *addrStr,NSString *typeStr);

@property(nonatomic,copy)void(^finishBlcok)(void);

@end

