//
//  MonitorCompanyModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/8.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MonitorCompanyModel : MTLModel <MTLJSONSerializing>

@property(nonatomic,copy)NSString *address;
@property(nonatomic,copy)NSString *companyName;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *isLook;
@property(nonatomic,strong)NSNumber *monitorId;
@property(nonatomic,strong)NSNumber *usrId;
@property(nonatomic,copy)NSString *monitorStatus;

@end
