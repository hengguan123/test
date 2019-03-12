//
//  MonitorContentModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/10.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MonitorContentModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *busiType;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *monitorType;
@property(nonatomic,copy)NSString *pn;
@property(nonatomic,copy)NSString *pbd;
@property(nonatomic,copy)NSString *nwLegal;
@property(nonatomic,copy)NSString *oldLegal;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *isLook;

@property(nonatomic,copy)NSString *uniquelyid;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,strong)NSNumber *monitorId;
@property(nonatomic,copy)NSString *ipc;
@property(nonatomic,copy)NSString *dbName;
@property(nonatomic,copy)NSString *companyName;
@property(nonatomic,copy)NSString *monitorStatus;
@property(nonatomic,strong)NSNumber *modelId;

@end
