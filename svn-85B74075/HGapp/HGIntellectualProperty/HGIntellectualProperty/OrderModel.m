//
//  OrderModel.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/18.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"buyUsrId":@"buyUsrId",
                @"orderId":@"orderId",
                @"sellerUsrId":@"sellerUsrId",
                @"orderPrice":@"orderPrice",
                @"createTime":@"createTime",
                @"orderDesc":@"orderDesc",
                @"orderNo":@"orderNo",
                @"orderStatus":@"orderStatus",
                @"updateTime":@"updateTime",
                @"listOrderInfo":@"listOrderInfo",
                @"errandId":@"errandId",
                @"payTime":@"listOrderPay.payEndTime",
             };
}

-(void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"listOrderInfo"]) {
        
        _listOrderInfo = [MTLJSONAdapter modelsOfClass:[ChildOrderModel class] fromJSONArray:value error:nil];
        if(value==nil)
        {
            return;
        }
        NSMutableString *str = [NSMutableString new];
        for (int i=0; i<_listOrderInfo.count; i++) {
            ChildOrderModel *childModel = [_listOrderInfo objectAtIndex:i];
            if (i==_listOrderInfo.count-1&&i!=0) {
                [str appendFormat:@"、%@等",childModel.goodsName];
            }
            else
            {
                [str appendFormat:@"、%@",childModel.goodsName];
            }
        }
        if(str.length>0){
            [str deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        
        _title = str;
    }
}




@end
