//
//  IPCModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/16.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface IPCModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *svTypeName;
@property(nonatomic,copy)NSString *svTypeCode;

@end
