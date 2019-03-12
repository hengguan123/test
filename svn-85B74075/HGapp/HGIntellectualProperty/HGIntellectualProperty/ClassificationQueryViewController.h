//
//  ClassificationQueryViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/20.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassificationQueryViewController : UIViewController

/// type  1.专利  2.商标  3.版权
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *companyName;
@property(nonatomic,copy)NSString *country;


@end
