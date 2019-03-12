//
//  HotSearchModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface HotSearchModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *keyword;

@end
