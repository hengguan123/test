//
//  AgentDomainModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/21.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface AgentDomainModel : MTLModel <MTLJSONSerializing>

@property(nonatomic,copy)NSString *classifyCode;
@property(nonatomic,copy)NSString *delFlag;
@property(nonatomic,strong)NSNumber *facilitatorId;
@property(nonatomic,strong)NSNumber *modelId;
@property(nonatomic,strong)NSNumber *price;
@property(nonatomic,copy)NSString *classifyName;

@end
