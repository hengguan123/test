//
//  Copyright2ViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/24.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Copyright2ViewController : UIViewController

@property(nonatomic,copy)void(^numBlock)(NSNumber *num);

-(void)searchWithSearchStr:(NSString *)searchStr type:(NSInteger)type;

@end
