//
//  MyPatentModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/28.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MyPatentModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *patentPn;
@property(nonatomic,copy)NSString *patentName;
@property(nonatomic,copy)NSString *pkind;
@property(nonatomic,copy)NSString *patentId;
@property(nonatomic,copy)NSString *company;
@property(nonatomic,copy)NSString *person;
@property(nonatomic,copy)NSString *pkinds;
@property(nonatomic,copy)NSString *dbName;

@end
