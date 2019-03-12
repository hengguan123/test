//
//  SearchCompanyViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCompanyModel.h"
@interface SearchCompanyViewController : UIViewController

@property(nonatomic,copy)void(^addBlock)(NSDictionary *dict);
@property(nonatomic,copy)MyCompanyModel *company;


@end
