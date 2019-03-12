//
//  BecomeAgentViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/9.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BecomeAgentViewController : UIViewController

@property(nonatomic,assign,getter=isFromInvite)BOOL fromInvite;
@property(nonatomic,copy)NSString *fromUid;

@end
