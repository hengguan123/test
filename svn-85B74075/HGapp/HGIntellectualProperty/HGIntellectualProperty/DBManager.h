//
//  DBManager.h
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface DBManager : NSObject

+(instancetype)share;

-(void)creatDB;
-(void)addKeyWord:(NSString *)keyWord toTableWithType:(int)type;
-(void)deleteDataWithTableType:(int)type;
-(NSArray *)getDataWithTableType:(int)type;


@end
