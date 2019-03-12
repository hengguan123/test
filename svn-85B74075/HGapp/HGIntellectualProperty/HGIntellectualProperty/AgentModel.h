//
//  AgentModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface AgentModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *provinceName;
@property(nonatomic,copy)NSString *starName;
@property(nonatomic,copy)NSString *starService;
@property(nonatomic,strong)NSNumber *usrId;
@property(nonatomic,copy)NSString *mobilePhone;
@property(nonatomic,copy)NSString *city;
@property(nonatomic,strong)NSNumber *facilitatorId;
@property(nonatomic,copy)NSString *facilitatorName;
@property(nonatomic,copy)NSString *serveBrief;
@property(nonatomic,copy)NSString *serveManifesto;
@property(nonatomic,strong)NSArray *queryListClassify;
@property(nonatomic,strong)NSArray *queryListRange;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *portraitUrl;
@property(nonatomic,strong)NSNumber *unitPrice;


@end
