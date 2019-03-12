//
//  ProgressModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/13.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ProgressModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *endTime;
@property(nonatomic,copy)NSString *errandStatusName;
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,copy)NSString *replyContent;
@property(nonatomic,strong)NSNumber *addAccounts;
@property(nonatomic,strong)NSNumber *errandId;
@property(nonatomic,strong)NSNumber *modelId;
@property(nonatomic,copy)NSString *errandStatus;

@end
