//
//  CopyrightModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/21.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface CopyrightModel : MTLModel<MTLJSONSerializing>
/// 登记号
@property(nonatomic,copy)NSString *registerNum;
/// 分类类型
@property(nonatomic,copy)NSString *classType;
/// 版权名称
@property(nonatomic,copy)NSString *copyrightName;
/// 软件简称
@property(nonatomic,copy)NSString *shortName;
/// 创作完成日期
@property(nonatomic,copy)NSString *createDate;
/// 版本号
@property(nonatomic,copy)NSString *version;
/// 著作权人（国籍）
@property(nonatomic,copy)NSString *owner;
/// 首次发表日期
@property(nonatomic,copy)NSString *publishDate;
/// 登记日期
@property(nonatomic,copy)NSString *registerDate;
/// 版权类型<COPY_TYPE> 0_软著 1_作品
@property(nonatomic,copy)NSString *type;
/// 创建时间<CREATE_TIME>
@property(nonatomic,copy)NSString *createTime;

@end
