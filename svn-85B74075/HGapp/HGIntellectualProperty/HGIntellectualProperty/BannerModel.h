//
//  BannerModel.h
//  Star
//
//  Created by GJ on 16/1/19.
//  Copyright © 2016年 GJ. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface BannerModel : MTLModel <MTLJSONSerializing>

@property(nonatomic,strong)NSNumber *sid;
@property(nonatomic,copy)NSString *skipType;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *skipLink;
@property(nonatomic,strong)NSString *title;


//@property(nonatomic,strong)NSString *createTime;
//@property(nonatomic,strong)NSString *pic;
//@property(nonatomic,strong)NSString *createUser;
//@property(nonatomic,strong)NSString *remark;
//@property(nonatomic,strong)NSNumber *adType;
//@property(nonatomic,strong)NSString *linkUrl;
//@property(nonatomic,strong)NSNumber *busId;
//@property(nonatomic,strong)NSNumber *busType;

@end
