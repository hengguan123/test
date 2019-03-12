//
//  BuyFilterViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BuyFilterViewController : UIViewController

@property (nonatomic,copy)void(^hiddenBlcok)(void);
@property(nonatomic,copy)void(^sureSelBlock)(BOOL ischina,NSString *addrcodes,NSString *typecodes,NSString *timeStr,NSString *ipcstr,NSString *valid);

@end
