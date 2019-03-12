//
//  CommentModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/15.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CommentModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *evalContent;
@property(nonatomic,copy)NSString *domainName;
@property(nonatomic,copy)NSString *errandTypeName;
@property(nonatomic,copy)NSString *busiTypeName;
@property(nonatomic,copy)NSString *evalLevel;
@property(nonatomic,copy)NSString *provinceName;
@property(nonatomic,copy)NSString *cityName;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *usrAlias;
@property(nonatomic,copy)NSString *portraitUrl;

@end
