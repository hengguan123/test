//
//  AttentionModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/11/2.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionModel : NSObject

@property(nonatomic,copy)NSString *addrCode;
@property(nonatomic,copy)NSString *addrName;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *departCode;
@property(nonatomic,copy)NSString *departName;
@property(nonatomic,strong)NSNumber *modelId;
@property(nonatomic,assign)BOOL isSel;
@property(nonatomic,copy)NSString *flag;

@end
