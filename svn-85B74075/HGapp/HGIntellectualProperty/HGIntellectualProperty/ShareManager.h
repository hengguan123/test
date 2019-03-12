//
//  ShareManager.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareManager : NSObject

+(instancetype)share;

-(void)shareWithShareUrl:(NSString *)url title:(NSString *)title subTitle:(NSString *)subTitle image:(UIImage *)image;


@end
