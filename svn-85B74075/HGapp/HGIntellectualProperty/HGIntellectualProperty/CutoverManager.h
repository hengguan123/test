//
//  CutoverManager.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/26.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SoftwareCopyrightModel,WorksCopyrightModel;
@interface CutoverManager : NSObject

+(instancetype)share;

/// 切换至专利详情
/*
    vc   从哪个页面跳转
    patentId 专利主键
    physicDb 来源库
    PKINDS 类型（ABCD等）
    monitorId 监控ID（可nil）
 */
+(void)openPatendDetailWithFromController:(UIViewController *)vc techId:(NSString *)patentId physicDb:(NSString *)physicDb PKINDS:(NSString *)PKINDS monitorId:(NSNumber *)monitorId title:(NSString *)patentTitle subTitle:(NSString *)patentAN share:(BOOL)enableShare;


/// 切换商标详情
/*
 regNo 商标注册号  主键
 intCls 商标分类
 monitorId 监控ID（可nil）
 */
+(void)openTrademarkDetailWithFromController:(UIViewController *)vc regNo:(NSString *)regNo intCls:(NSString *)intCls name:(NSString *)name owner:(NSString *)owner usrPhone:(NSString *)usrPhone;

/// 切换版权详情
+(void)openCopyrightDetailWithFromController:(UIViewController *)vc softwareModel:(SoftwareCopyrightModel *)softwareModel worksModel:(WorksCopyrightModel *)worksModel;


+(void)downloadAndOpenFileWithUrl:(NSString *)url fromController:(UIViewController *)vc;



@end
