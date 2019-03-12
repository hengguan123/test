//
//  FilterTypeModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/23.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterTypeModel : NSObject

@property(nonatomic,copy)NSString *code;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)BOOL isSel;
@property(nonatomic,strong)NSArray *childArray;
@property(nonatomic,copy)NSString *type;
@property(nonatomic,strong)NSNumber *level;

@end
