//
//  ErrandClassModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/6/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface ErrandClassModel : MTLModel<MTLJSONSerializing>

@property(nonatomic,copy)NSString *createTime;//9
@property(nonatomic,copy)NSString *dictionaryCode;//4
@property(nonatomic,copy)NSString *dictionaryName;//2
@property(nonatomic,copy)NSString *fileRemark;//8
@property(nonatomic,copy)NSString *superDictionaryCode;//11
@property(nonatomic,copy)NSString *updateTime;//1
@property(nonatomic,copy)NSString *dictionaryStatus;//6
@property(nonatomic,copy)NSString *isNode;//15
@property(nonatomic,copy)NSString *starService;
@property(nonatomic,copy)NSString *delFlag;//5
@property(nonatomic,strong)NSArray *listSerTypeInfo;
@property(nonatomic,strong)NSNumber *rangeId;
@property(nonatomic,strong)NSNumber *addUsrId;//3
@property(nonatomic,strong)NSNumber *dictionaryId;//12
@property(nonatomic,strong)NSNumber *fileNum;//10
@property(nonatomic,strong)NSNumber *price;//7
@property(nonatomic,copy)NSString *remark;
@property(nonatomic,strong)NSNumber *modelId;//14
@property(nonatomic,strong)NSNumber *updateUsrId;//13
@property(nonatomic,copy)NSString *auditStatus;

@end
