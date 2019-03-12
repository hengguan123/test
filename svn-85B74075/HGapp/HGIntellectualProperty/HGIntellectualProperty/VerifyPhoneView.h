//
//  VerifyPhoneView.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2018/3/21.
//  Copyright © 2018年 HG. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VerifyPhoneViewDelegate <NSObject>

-(void)verificationPassedWithPhone:(NSString *)phone;

@end

@interface VerifyPhoneView : UIView

@property(nonatomic,weak)id<VerifyPhoneViewDelegate>delegate;

-(void)show;


@end
