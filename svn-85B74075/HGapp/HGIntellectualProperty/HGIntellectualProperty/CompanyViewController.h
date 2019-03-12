//
//  CompanyViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CompanyViewController : UIViewController

@property(nonatomic,copy)NSString *companyName;
/// 1 专利    2 商标
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *dbname;


@end
