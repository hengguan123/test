//
//  SystemMessageModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SystemMessageModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *msgContent;
@property(nonatomic,strong)NSNumber *msgId;
@property(nonatomic,copy)NSString *msgTitle;
@property(nonatomic,copy)NSString *msgType;
@property(nonatomic,copy)NSString *msgTypeName;
@property(nonatomic,copy)NSString *readStatus;
@property(nonatomic,strong)NSNumber *usrId;

@end
