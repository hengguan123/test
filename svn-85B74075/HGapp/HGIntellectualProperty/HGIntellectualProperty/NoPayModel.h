//
//  NoPayModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/14.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface NoPayModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,strong)NSNumber *busId;
@property(nonatomic,copy)NSString *busiQuality;
@property(nonatomic,copy)NSString *businessType;
@property(nonatomic,copy)NSString *businessTypeName;
@property(nonatomic,copy)NSString *classifyName;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,strong)NSNumber *faciId;
@property(nonatomic,strong)NSNumber *fileNum;
@property(nonatomic,strong)NSNumber *goodsId;
@property(nonatomic,copy)NSString *goodsImg;
@property(nonatomic,copy)NSString *goodsName;
@property(nonatomic,copy)NSString *goodsType;
@property(nonatomic,strong)NSNumber *modelId;
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)NSString *type;

@property(nonatomic,assign,getter=isSelected)BOOL selected;

+(NSArray *)arrarWithArray:(NSArray *)array;


@end
