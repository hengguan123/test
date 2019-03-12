//
//  OrganizationModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/17.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OrganizationModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *departName;
@property(nonatomic,strong)NSArray *listAddr;
@property(nonatomic,copy)NSString *departCode;
@property(nonatomic,copy)NSString *dictionaryName;
@property(nonatomic,copy)NSString *dictionaryCode;
@property(nonatomic,copy)NSString *addrCode;
@property(nonatomic,copy)NSString *addrName;

@end
