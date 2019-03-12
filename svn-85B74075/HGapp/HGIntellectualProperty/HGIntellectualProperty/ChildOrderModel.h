//
//  ChildOrderModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ChildOrderModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSNumber *busId;
@property(nonatomic,strong)NSNumber *orderInfoId;
@property(nonatomic,strong)NSNumber *goodsPrice;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *goodsImg;
@property(nonatomic,copy)NSString *goodsName;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *orderStatus;
@property(nonatomic,copy)NSString *superOrderNo;
@property(nonatomic,copy)NSString *updateTime;

@property(nonatomic,copy)NSString *busiQuality;
@property(nonatomic,strong)NSNumber *businessId;
@property(nonatomic,copy)NSString *businessType;
@property(nonatomic,copy)NSString *type;
@end
