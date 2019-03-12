//
//  BuyInfoPopUpView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/25.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyInfoPopUpView : UIView<UITextFieldDelegate>

-(void)buyWithErrandModel:(PatentModel *)model;
-(void)show;
-(void)dismiss;

@end
