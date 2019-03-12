//
//  DBManager.m
//  HGIntellectualProperty
//
//  Created by 耿广杰 on 2017/7/7.
//  Copyright © 2017年 HG. All rights reserved.
//

#import "DBManager.h"

@interface DBManager()

@property(nonatomic,strong)FMDatabase *db;

@end
@implementation DBManager

+(instancetype)share
{
    static DBManager *manger = nil;
    static dispatch_once_t onceToken1;
    dispatch_once(&onceToken1, ^{
        manger = [[DBManager alloc] init];
    });
    return manger;
}
-(void)creatDB
{
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    NSString *fileName = [doc stringByAppendingPathComponent:@"hotSearch.sqlite"];
    //2.获得数据库
    _db = [FMDatabase databaseWithPath:fileName];
    //3.使用如下语句，如果打开失败，可能是权限不足或者资源不足。通常打开完操作操作后，需要调用 close 方法来关闭数据库。在和数据库交互 之前，数据库必须是打开的。如果资源或权限不足无法打开或创建数据库，都会导致打开失败。
    if ([self.db open])
    {
        //4.创表
        BOOL result1 = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS allHotSearch (keyword text PRIMARY KEY NOT NULL);"];
        BOOL result2 = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS patentHotSearch (keyword text PRIMARY KEY NOT NULL);"];
        BOOL result3 = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS trademarkHotSearch (keyword text PRIMARY KEY NOT NULL);"];
        BOOL result4 = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS copyrightHotSearch (keyword text PRIMARY KEY NOT NULL);"];
        BOOL result5 = [self.db executeUpdate:@"CREATE TABLE IF NOT EXISTS propertyHotSearch (keyword text PRIMARY KEY NOT NULL);"];
        if (result1&&result2&&result3&&result4&&result5) {
            NSLog(@"成功创表");
        } else {
            NSLog(@"创表失败");
        }
    }
    [self.db close];
}

-(void)addKeyWord:(NSString *)keyWord toTableWithType:(int)type
{
    if ([self.db open]) {
        switch (type) {
            case 1:
            {
                [self.db executeUpdate:@"INSERT INTO allHotSearch (keyword) VALUES (?);",keyWord];
            }
                break;
            case 2:
            {
                [self.db executeUpdate:@"INSERT INTO patentHotSearch (keyword) VALUES (?);",keyWord];
            }
                break;
            case 3:
            {
                [self.db executeUpdate:@"INSERT INTO trademarkHotSearch (keyword) VALUES (?);",keyWord];
            }
                break;
            case 4:
            {
                [self.db executeUpdate:@"INSERT INTO copyrightHotSearch (keyword) VALUES (?);",keyWord];
            }
            case 5:
            {
                [self.db executeUpdate:@"INSERT INTO propertyHotSearch (keyword) VALUES (?);",keyWord];
            }
                break;
                
            default:
                break;
        }
    }
    [self.db close];
    
}

-(void)deleteDataWithTableType:(int)type
{
    if ([self.db open]) {
        switch (type) {
            case 1:
                [self.db executeUpdate:@"DELETE FROM allHotSearch"];
                break;
            case 2:
                [self.db executeUpdate:@"DELETE FROM patentHotSearch"];
                break;
            case 3:
                [self.db executeUpdate:@"DELETE FROM trademarkHotSearch"];
                break;
            case 4:
                [self.db executeUpdate:@"DELETE FROM copyrightHotSearch"];
                break;
            case 5:
                [self.db executeUpdate:@"DELETE FROM propertyHotSearch"];
                break;
            default:
                break;
        }
    }
    [self.db close];
}

-(NSArray *)getDataWithTableType:(int)type
{
    NSMutableArray *dataArray=[NSMutableArray new];
    FMResultSet *rs;
    if ([self.db open]) {
        switch (type) {
            case 1:
                rs = [self.db executeQuery:@"SELECT * FROM allHotSearch"];
                break;
            case 2:
                rs = [self.db executeQuery:@"SELECT * FROM patentHotSearch"];
                break;
            case 3:
                rs = [self.db executeQuery:@"SELECT * FROM trademarkHotSearch"];
                break;
            case 4:
                rs = [self.db executeQuery:@"SELECT * FROM copyrightHotSearch"];
                break;
            case 5:
                rs = [self.db executeQuery:@"SELECT * FROM propertyHotSearch"];
                break;
            default:
                break;
        }
    }
    // 遍历结果集
    while ([rs next]) {
        HotSearchModel *model = [HotSearchModel new];
        model.keyword = [rs stringForColumn:@"keyword"];
        [dataArray addObject:model];
    }
    [self.db close];
    return dataArray;
}

@end
