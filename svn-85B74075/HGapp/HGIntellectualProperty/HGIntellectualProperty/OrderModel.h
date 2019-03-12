//
//  OrderModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OrderModel : MTLModel<MTLJSONSerializing>

/// 买家
@property(nonatomic,strong)NSNumber *buyUsrId;
@property(nonatomic,strong)NSNumber *orderId;
/// 代理人
@property(nonatomic,strong)NSNumber *sellerUsrId;
@property(nonatomic,strong)NSNumber *orderPrice;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *orderDesc;
@property(nonatomic,copy)NSString *orderNo;
@property(nonatomic,copy)NSString *orderStatus;
@property(nonatomic,copy)NSString *updateTime;
/// 子订单
@property(nonatomic,strong)NSArray *listOrderInfo;
@property(nonatomic,strong)NSNumber *errandId;

@property(nonatomic,copy)NSString *title;
//@property(nonatomic,strong)NSDictionary *listOrderPay;
@property(nonatomic,copy)NSString *payTime;


@end
