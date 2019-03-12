//
//  FilterManager.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterManager : NSObject

-(instancetype _Nullable )initWithFilterVc:(UIViewController *_Nullable)filterVc;
-(void)show;
-(void)hidden;

-(void)sureCompletion:(void (^ __nullable)(BOOL finished))completion;

@end
