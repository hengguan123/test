//
//  AreaModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/6.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface AreaModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *addrCode;
@property(nonatomic,copy)NSString *addrPost;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *updateTime;
@property(nonatomic,copy)NSString *addrName;
@property(nonatomic,copy)NSString *superAddrCode;
@property(nonatomic,copy)NSString *addrStatus;
@property(nonatomic,strong)NSNumber *updateUsrId;
@property(nonatomic,strong)NSNumber *addUsrId;
@property(nonatomic,strong)NSNumber *addrId;
@property(nonatomic,strong)NSNumber *addrLevel;

@property(nonatomic,strong)NSArray *subAddsArray;
@property(nonatomic,assign,getter=isOpen)BOOL open;
@property(nonatomic,assign,getter=isSelected)BOOL selected;


@end
