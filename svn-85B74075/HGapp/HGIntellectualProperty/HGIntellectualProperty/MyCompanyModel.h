//
//  MyCompanyModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/28.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface MyCompanyModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *selKeyword;
@property(nonatomic,strong)NSNumber *keywordId;

@end
