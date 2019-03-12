//
//  FilterCountryViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/19.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCountryViewController : UIViewController

@property(nonatomic,copy)void(^selAddBlock)(AreaModel *model,BOOL ischina);
@property(nonatomic,copy)void(^selTypeBlock)(NSString *typeCode);
@property(nonatomic,copy)void(^sureSelBlock)(BOOL ischina,NSString *addrcodes,NSString *typecodes);

@property(nonatomic,copy)void(^selTrademarkTypeBlock)(NSString *typeStr);
@property(nonatomic,assign)HotSearchViewType type;


@end
