//
//  BusinessChildViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessChildViewController : UIViewController

/// 1专利   2其他
@property(nonatomic,strong)NSString *type;

@property(nonatomic,strong)NSArray *domainArray;
@property(nonatomic,strong)NSArray *typeArray;

@property(nonatomic,assign,getter=isEditing)BOOL editing;




@end
