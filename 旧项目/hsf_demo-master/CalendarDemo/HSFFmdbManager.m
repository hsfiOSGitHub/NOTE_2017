//
//  HSFFmdbManager.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/4.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "HSFFmdbManager.h"

#import "FMDB.h"

static HSFFmdbManager *manager;
@implementation HSFFmdbManager
//单例的创建
+(instancetype)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [[HSFFmdbManager alloc]init];
        }
    });
    return manager;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [super allocWithZone:zone];
        }
    });
    return manager;
}
#pragma mark --数据库路径
+(NSString *)dbPathWithDBName:(NSString *)dbName{
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [library[0] stringByAppendingPathComponent:dbName];
    NSLog(@"%@", dbPath);
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isExist = [fm fileExistsAtPath:dbPath];
    if (!isExist) {
        //拷贝数据库
        //NSString *backupDbPath =[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hospital.db"];
        NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:dbName ofType:nil];
        NSError *error;
        BOOL cp = [fm copyItemAtPath:backupDbPath toPath:dbPath error:&error];
        if (cp) {
            NSLog(@"数据库拷贝成功");
        }else{
            NSLog(@"数据库拷贝失败：%@",[error localizedDescription]);
        }
    }
    return dbPath;
}
#pragma mark --创建数据库
-(FMDatabase *)getDBWithDBName:(NSString *)dbName {
    NSString *dbPath = [HSFFmdbManager dbPathWithDBName:dbName];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    if (![db open]) {
        NSLog(@"无法获取数据库");
        return nil;
    }
    return db;
}
#pragma mark --给指定数据库建表
-(void)DataBase:(FMDatabase *)db createTable:(NSString *)tableName keyTypes:(NSDictionary *)keyTypes {
    if (![self DataBase:db tableExist:tableName]) {
        NSLog(@"该表已经存在");
        return;
    }
    if ([self isOpenDatabese:db]) {
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ (",tableName]];
        int count = 0;
        for (NSString *key in keyTypes) {
            count++;
            [sql appendString:key];
            [sql appendString:@" "];
            [sql appendString:[keyTypes valueForKey:key]];
            if (count != [keyTypes count]) {
                [sql appendString:@", "];
            }
        }
        [sql appendString:@")"];
        NSLog(@"%@", sql);
        [db executeUpdate:sql];
    }
}
#pragma mark --给指定数据库的表添加值
-(void)DataBase:(FMDatabase *)db insertKeyValues:(NSDictionary *)keyValues intoTable:(NSString *)tableName {
    if ([self isOpenDatabese:db]) {
        //        int count = 0;
        //        NSString *Key = [[NSString alloc] init];
        //        for (NSString *key in keyValues) {
        //            if(count == 0){
        //                NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"INSERT INTO %@ (%@) VALUES (?)",tableName, key]];
        //                [db executeUpdate:sql,[keyValues valueForKey:key]];
        //                Key = key;
        //            }else
        //            {
        //                NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", tableName, key, Key]];
        //                [db executeUpdate:sql,[keyValues valueForKey:key],[keyValues valueForKey:Key]];
        //            }
        //            count++;
        //        }
        
        NSArray *values = [keyValues allValues];
        NSArray *keys = [keyValues allKeys];
        NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"INSERT INTO %@ (", tableName]];
        NSInteger count = 0;
        for (NSString *key in keys) {
            [sql appendString:key];
            count ++;
            if (count < [keys count]) {
                [sql appendString:@", "];
            }
        }
        [sql appendString:@") VALUES ("];
        for (int i = 0; i < [values count]; i++) {
            [sql appendString:@"?"];
            if (i < [values count] - 1) {
                [sql appendString:@","];
            }
        }
        [sql appendString:@")"];
        NSLog(@"%@", sql);
        [db executeUpdate:sql withArgumentsInArray:values];
    }
    
}
#pragma mark --删除指定数据库的某条数据
-(void)DataBase:(FMDatabase *)db deleteFromTable:(NSString *)tableName whereCondition:(NSDictionary *)condition {
    NSString *sql = [NSString stringWithFormat:
                     @"DELETE FROM %@ WHERE %@ = ?",
                     tableName, [condition allKeys][0]];
    [db executeUpdate:sql, [condition valueForKey:[condition allKeys][0]]];
}
#pragma mark --给指定数据库的表更新值
-(void)DataBase:(FMDatabase *)db updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValues {
    if ([self isOpenDatabese:db]) {
        for (NSString *key in keyValues) {
            NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ?", tableName, key]];
            [db executeUpdate:sql,[keyValues valueForKey:key]];
        }
    }
}
#pragma mark --条件更新
-(void)DataBase:(FMDatabase *)db updateTable:(NSString *)tableName setKeyValues:(NSDictionary *)keyValues whereCondition:(NSDictionary *)condition {
    if ([self isOpenDatabese:db]) {
        for (NSString *key in keyValues) {
            NSMutableString *sql = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"UPDATE %@ SET %@ = ? WHERE %@ = ?", tableName, key, [condition allKeys][0]]];
            
            NSLog(@"%@",sql);
            [db executeUpdate:sql,[keyValues valueForKey:key],[condition valueForKey:[condition allKeys][0]]];
        }
    }
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>查询>>>>>>>>>>>>>>>>>>>>>>>>>

#pragma mark --查询数据库表中的所有值
-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName limitNum:(NSInteger) limitNmu{
    FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ LIMIT %ld",tableName,(long)limitNmu]];
    return [self getArrWithDataBase:db FMResultSet:result keyTypes:keyTypes];
}
#pragma mark --条件查询数据库中的数据
-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereCondition:(NSDictionary *)condition limitNum:(NSInteger) limitNmu{
    if ([self isOpenDatabese:db]) {
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ? LIMIT %ld",tableName, [condition allKeys][0], (long)limitNmu], [condition valueForKey:[condition allKeys][0]]];
        
        return [self getArrWithDataBase:db FMResultSet:result keyTypes:keyTypes];
    }else
        return nil;
}
#pragma mark --模糊查询 某字段以指定字符串开头的数据
-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key beginWithStr:(NSString *)str limitNum:(NSInteger) limitNmu{
    if ([self isOpenDatabese:db]) {
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE '%@%%' LIMIT %ld",tableName, key, str, (long)limitNmu]];
        return [self getArrWithDataBase:db FMResultSet:result keyTypes:keyTypes];
    }else
        return nil;
    
}
#pragma mark --模糊查询 某字段包含指定字符串的数据
-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key containStr:(NSString *)str limitNum:(NSInteger) limitNmu{
    if ([self isOpenDatabese:db]) {
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE '%%%@%%' LIMIT %ld",tableName, key, str, (long)limitNmu]];
        return [self getArrWithDataBase:db FMResultSet:result keyTypes:keyTypes];
    }else
        return nil;
}
#pragma mark --模糊查询 某字段以指定字符串结尾的数据
-(NSArray *)DataBase:(FMDatabase *)db selectKeyTypes:(NSDictionary *)keyTypes fromTable:(NSString *)tableName whereKey:(NSString *)key endWithStr:(NSString *)str limitNum:(NSInteger) limitNmu{
    if ([self isOpenDatabese:db]) {
        FMResultSet *result =  [db executeQuery:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ LIKE '%%%@' LIMIT %ld",tableName, key, str, (long)limitNmu]];
        
        return [self getArrWithDataBase:db FMResultSet:result keyTypes:keyTypes];
    }else
        return nil;
}

#pragma mark --清理指定数据库中的数据
-(void)clearDatabase:(FMDatabase *)db from:(NSString *)tableName {
    if ([self isOpenDatabese:db]) {
        [db executeUpdate:[NSString stringWithFormat:@"DELETE FROM %@",tableName]];
    }
}

#pragma mark --CommonMethod
-(NSArray *)getArrWithDataBase:(FMDatabase *)db FMResultSet:(FMResultSet *)result keyTypes:(NSDictionary *)keyTypes {
    NSMutableArray *tempArr = [NSMutableArray array];
    while ([result next]) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        for (int i = 0; i < keyTypes.count; i++) {
            NSString *key = [keyTypes allKeys][i];
            NSString *value = [keyTypes valueForKey:key];
            if ([value isEqualToString:@"text"]) {
                //                字符串
                [tempDic setValue:[result stringForColumn:key] forKey:key];
            }else if([value isEqualToString:@"blob"])
            {
                //                二进制对象
                [tempDic setValue:[result dataForColumn:key] forKey:key];
            }else if ([value isEqualToString:@"integer"] || [value isEqualToString:@"varchar"])
            {
                //                带符号整数类型
                [tempDic setValue:[NSNumber numberWithInt:[result intForColumn:key]]forKey:key];
            }else if ([value isEqualToString:@"boolean"])
            {
                //                BOOL型
                [tempDic setValue:[NSNumber numberWithBool:[result boolForColumn:key]] forKey:key];
                
            }else if ([value isEqualToString:@"date"])
            {
                //                date
                [tempDic setValue:[result dateForColumn:key] forKey:key];
            }
            
        }
        [tempArr addObject:tempDic];
    }
    [db close];
    return tempArr;
    
}
-(BOOL)isOpenDatabese:(FMDatabase *)db {
    if (![db open]) {
        [db open];
    }
    return YES;
}
#pragma mark --判断数据库中的表是否存在
// 判断是否存在表
- (BOOL)DataBase:(FMDatabase *)db tableExist:(NSString *)tableName {
    FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?", tableName];
    while ([rs next]){
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"isTableOK %ld", (long)count);
        
        if (0 == count){
            return NO;
        }else{
            return YES;
        }
    }
    
    return NO;
}

//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

@end
