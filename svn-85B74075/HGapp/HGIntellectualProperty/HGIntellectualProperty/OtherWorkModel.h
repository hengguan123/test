//
//  OtherWorkModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/9.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface OtherWorkModel : MTLModel <MTLJSONSerializing>

@property(nonatomic,copy)NSString *dictionaryName;
@property(nonatomic,copy)NSString *dictionaryCode;
//@property(nonatomic,copy)NSString *dictionaryStatus;
@property(nonatomic,copy)NSString *superDictionaryCode;
//@property(nonatomic,strong)NSNumber *dictionaryId;
@property(nonatomic,strong)NSArray *listChildDict;
@property(nonatomic,strong)NSArray *listChild;
//@property(nonatomic,copy)NSString *fileRemark;
//@property(nonatomic,strong)NSNumber *fileNum;
//@property(nonatomic,copy)NSString *code;

@property(nonatomic,strong)NSArray *listData;
@property(nonatomic,strong)NSArray *listOther;


@end
