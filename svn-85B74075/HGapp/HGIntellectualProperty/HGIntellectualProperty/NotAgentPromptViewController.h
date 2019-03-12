//
//  NotAgentPromptViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/9.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotAgentPromptViewController : UIViewController

@property(nonatomic,copy)NSString *infoStr;
@property(nonatomic,copy)void(^block)(void);

@end
