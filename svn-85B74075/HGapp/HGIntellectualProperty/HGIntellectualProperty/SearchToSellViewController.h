//
//  SearchToSellViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/28.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchToSellViewController : UIViewController

@property(nonatomic,copy)void(^selBlock)(PatentModel *model);
@property(nonatomic,copy)void(^selArrayBlock)(NSArray *modelArray);

@property(nonatomic,assign)NSInteger totalNum;


@end
