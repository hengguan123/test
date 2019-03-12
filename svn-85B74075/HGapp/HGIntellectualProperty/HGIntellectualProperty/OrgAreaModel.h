//
//  OrgAreaModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/8/17.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OrgAreaModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *addrName;
@property(nonatomic,strong)NSArray *listAddr;
@property(nonatomic,strong)NSArray *listDept;
@property(nonatomic,copy)NSString *addrCode;


@end
