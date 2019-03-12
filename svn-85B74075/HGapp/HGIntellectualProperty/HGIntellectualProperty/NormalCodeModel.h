//
//  NormalCodeModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface NormalCodeModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *code;
@property(nonatomic,assign,getter=isSelected)BOOL selected;

@end
