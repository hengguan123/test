//
//  GrabErrandModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GrabErrandModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSNumber *errandId;
@property(nonatomic,copy)NSString *replyContent;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *errandStatusName;//状态
@property(nonatomic,copy)NSString *busiTypeName;
@property(nonatomic,copy)NSString *dwellAddrName;
@property(nonatomic,copy)NSString *domainName;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *isReply;
@property(nonatomic,copy)NSString *usrName;
@property(nonatomic,copy)NSString *provinceName;
@property(nonatomic,strong)NSNumber *price;
@property(nonatomic,copy)NSString *errandTitle;
@property(nonatomic,copy)NSString *errandTypeName;
@end
