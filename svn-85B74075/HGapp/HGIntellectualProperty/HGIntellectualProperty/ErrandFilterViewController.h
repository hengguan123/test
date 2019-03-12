//
//  ErrandFilterViewController.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/25.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ErrandFilterViewController : UIViewController

@property(nonatomic,copy)void(^selectItemsBlock)(NSString *addrStr,NSString *typeLikeStr,NSString *subTpeyStr);

@end
