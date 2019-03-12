//
//  VersionModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/9/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface VersionModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *versionNo;
/// 强制更新  0强制  1不强制
@property(nonatomic,copy)NSString *coerceStatus;
@property(nonatomic,copy)NSString *versionDesc;
@property(nonatomic,copy)NSString *versionInfo;

@end
