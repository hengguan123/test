//
//  RecordingModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/27.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface RecordingModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *bankOpen;
@property(nonatomic,copy)NSString *bankLocale;
@property(nonatomic,copy)NSString *bankCardNo;
@property(nonatomic,copy)NSString *optStatus;
@property(nonatomic,copy)NSString *usrRealName;
@property(nonatomic,strong)NSNumber *usrId;
@property(nonatomic,copy)NSString *optType;
@property(nonatomic,strong)NSNumber *optMoney;
@property(nonatomic,copy)NSString *optDesc;
@property(nonatomic,strong)NSNumber *modelId;
@property(nonatomic,copy)NSString *week;

@property(nonatomic,assign,getter=isOpen)BOOL open;


@end
