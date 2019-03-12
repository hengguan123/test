//
//  InformationFilterViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/17.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformationFilterViewController : UIViewController
@property (nonatomic,copy)void(^hiddenBlcok)(void);
@property (nonatomic,copy)void(^selFinishBlcok)(NSString *orgStr,NSString *areaStr,NSString *orgTypeStr);
-(void)reloadata;

@end
