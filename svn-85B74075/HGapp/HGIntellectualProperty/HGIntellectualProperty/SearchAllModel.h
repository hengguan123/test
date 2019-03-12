//
//  SearchAllModel.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/12.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SearchAllModel : MTLModel <MTLJSONSerializing>
/// 公司名
@property(nonatomic,copy)NSString *companyName;
/// 专利数
@property(nonatomic,strong)NSNumber *patentNum;
/// 商标数
@property(nonatomic,strong)NSNumber *tradeNum;
/// 版权数
@property(nonatomic,strong)NSNumber *copyrightNum;
/// 地址
@property(nonatomic,copy)NSString *address;
@end
