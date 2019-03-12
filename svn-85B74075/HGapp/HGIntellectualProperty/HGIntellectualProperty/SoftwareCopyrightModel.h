//
//  SoftwareCopyrightModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SoftwareCopyrightModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *number;
@property(nonatomic,copy)NSString *category;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *owner;
@property(nonatomic,copy)NSString *nationality;
@property(nonatomic,copy)NSString *recordDate;
@property(nonatomic,copy)NSString *postDate;


@end
