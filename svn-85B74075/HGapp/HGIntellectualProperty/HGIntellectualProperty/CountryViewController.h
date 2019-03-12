//
//  CountryViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/20.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountryViewController : UIViewController

@property(nonatomic,copy)void(^selCountryBlock)(NSString *country);
@property(nonatomic,copy)void(^finishBlock)(void);


@end
