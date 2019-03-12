//
//  AgentFilterViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/4.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentFilterViewController : UIViewController

@property(nonatomic,copy)void (^dismissBlock)(void);
@property(nonatomic,copy)void(^sureSelBlock)(NSString *addrcodes,NSString *typecodes,NSInteger star,NSString *domaincodes);

@property(nonatomic,copy)NSString *selTypeCode;
@property(nonatomic,copy)NSString *selDomainCode;
@property(nonatomic,copy)NSString *selCityCode;
@property(nonatomic,assign)NSInteger star;


@end
