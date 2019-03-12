//
//  ErrandModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/5.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ErrandModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSNumber *errandId;

@property(nonatomic,copy)NSString *updateTime;
//@property(nonatomic,strong)NSNumber *updateAccounts;
@property(nonatomic,copy)NSString *errandTitle;
@property(nonatomic,copy)NSString *isRobOrder;//0_未被抢单 1_已被抢单

//@property(nonatomic,copy)NSString *reseField1;
//@property(nonatomic,copy)NSString *publishStatus;
@property(nonatomic,copy)NSString *usrName;
@property(nonatomic,strong)NSNumber *usrId;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,strong)NSNumber *price;
@property(nonatomic,copy)NSString *fileUrl;
@property(nonatomic,copy)NSString *remark;

@property(nonatomic,copy)NSString *dwellAddr;
@property(nonatomic,copy)NSString *busiType;
@property(nonatomic,copy)NSString *errandType;
@property(nonatomic,copy)NSString *classifyDomain;

@property(nonatomic,copy)NSString *busiTypeName;
@property(nonatomic,copy)NSString *dwellAddrName;
@property(nonatomic,copy)NSString *domainName;
@property(nonatomic,copy)NSString *errandTypeName;
@property(nonatomic,copy)NSString *time;

@property(nonatomic,copy)NSString *replyContent;
@property(nonatomic,copy)NSString *errandStatusName;//状态
@property(nonatomic,copy)NSString *errandStatus;//状态

@property(nonatomic,copy)NSString *isReply;
@property(nonatomic,copy)NSString *provinceName;
@property(nonatomic,copy)NSString *robTime;
@property(nonatomic,strong)NSNumber *robId;
@property(nonatomic,strong)NSNumber *faciId;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *superOrderNo;
@property(nonatomic,strong)NSNumber *orderId;
@property(nonatomic,copy)NSString *faciName;
@property(nonatomic,copy)NSString *phone;
@property(nonatomic,copy)NSString *faciPhone;
///是否内部人员发布差事
@property(nonatomic,copy)NSString *isInside;

@end
