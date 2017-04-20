//
//  HSFFmdbManager+task.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/10.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "HSFFmdbManager+task.h"

@implementation HSFFmdbManager (task)

//添加数据
-(void)insertNewTask:(TaskModel *)model{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"task.sqlite"];
    NSString *tableName = @"task";
    //数据
    NSDictionary *dic = @{@"task_id":model.task_id,
                          @"date":model.date,
                          @"title":model.title,
                          @"time":model.time,
                          @"isFinished":model.isFinished};
    
    NSMutableDictionary *mtDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //为null时移除,不插入数据库
        if ([obj isKindOfClass:[NSNull class]]) {
            [mtDic removeObjectForKey:key];
        }
    }];
    //添加
    [manager DataBase:db insertKeyValues:mtDic intoTable:tableName];
}

//删除数据 --条件删除
-(void)deleteTaskWhereCondition:(NSDictionary *)condition{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"task.sqlite"];
    NSString *tableName = @"task";
    [manager DataBase:db deleteFromTable:tableName whereCondition:condition];
}

//数据修改 --条件修改
-(void)modifyTaskWith:(TaskModel *)model whereCondition:(NSDictionary *)condition{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"task.sqlite"];
    NSString *tableName = @"task";
    //数据
    NSDictionary *dic = @{@"task_id":model.task_id,
                          @"date":model.date,
                          @"title":model.title,
                          @"time":model.time,
                          @"isFinished":model.isFinished};
    
    NSMutableDictionary *mtDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //为null时移除,不插入数据库
        if ([obj isKindOfClass:[NSNull class]]) {
            [mtDic removeObjectForKey:key];
        }
    }];
    //修改
    [manager DataBase:db updateTable:tableName setKeyValues:mtDic whereCondition:condition];
}

//读取数据 --全部数据
-(NSArray *)readAllTasks{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"task.sqlite"];
    NSString *tableName = @"task";
    //数据
    NSDictionary *keyTypes = @{@"task_id":@"integer",
                               @"date":@"text",
                               @"title":@"text",
                               @"time":@"text",
                               @"isFinished":@"text"};
    
    NSInteger limitNum = -1;
    //执行查询
    NSArray *result = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName limitNum:limitNum];
    //转模型
    NSMutableArray *modelResult = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TaskModel *model = [TaskModel modelWithDic:obj];
        [modelResult addObject:model];
    }];
    return modelResult;
}

//读取数据 --条件读取
-(NSArray *)readTaskModelFromDBWhereCondition:(NSDictionary *)condition{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"task.sqlite"];
    NSString *tableName = @"task";
    //数据
    NSDictionary *keyTypes = @{@"task_id":@"integer",
                               @"date":@"text",
                               @"title":@"text",
                               @"time":@"text",
                               @"isFinished":@"text"};
    
    NSInteger limitNum = -1;
    //执行查询
    NSArray *result = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName whereCondition:condition limitNum:limitNum];
    //转模型
    NSMutableArray *modelResult = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TaskModel *model = [TaskModel modelWithDic:obj];
        [modelResult addObject:model];
    }];
    return modelResult;
}

//清除缓存 --全部数据
-(void)cleanDisk_Task{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"task.sqlite"];
    NSString *tableName = @"task";
    //将数据库中的数据全部清除
    [manager clearDatabase:db from:tableName];
}

@end
