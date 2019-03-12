//
//  BuyInformationModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/10/24.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuyInformationModel : NSObject

@property (nonatomic,copy)NSString *busiQuality;
@property (nonatomic,copy)NSString *businessName;
@property (nonatomic,copy)NSString *businessType;
@property (nonatomic,copy)NSString *createTime;
@property (nonatomic,strong)NSNumber *businessId;
@property (nonatomic,strong)NSNumber *usrId;
@property (nonatomic,strong)NSNumber *modelId;
@property (nonatomic,copy)NSString *price;


@end
