//
//  HSFFmdbManager+schedule.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/4.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "HSFFmdbManager+schedule.h"

@implementation HSFFmdbManager (schedule)

//添加数据
-(void)insertNewSchedule:(ScheduleModel *)model{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"schedule.sqlite"];
    NSString *tableName = @"schedule";
    //数据
    NSDictionary *dic = @{@"date":model.date,
                          @"schedule_id":model.schedule_id,
                          @"name":model.name,
                          @"emergency":model.emergency,
                          @"start_time":model.start_time,
                          @"end_time":model.end_time,
                          @"address":model.address,
                          @"alarm":model.alarm,
                          @"tags":model.tags,
                          @"content":model.content};
    
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
-(void)deleteScheduleWhereCondition:(NSDictionary *)condition{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"schedule.sqlite"];
    NSString *tableName = @"schedule";
    [manager DataBase:db deleteFromTable:tableName whereCondition:condition];
}

//数据修改 --条件修改
-(void)modifyScheduleWith:(ScheduleModel *)model whereCondition:(NSDictionary *)condition{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"schedule.sqlite"];
    NSString *tableName = @"schedule";
    //数据
    NSDictionary *dic = @{@"date":model.date,
                          @"schedule_id":model.schedule_id,
                          @"name":model.name,
                          @"emergency":model.emergency,
                          @"start_time":model.start_time,
                          @"end_time":model.end_time,
                          @"address":model.address,
                          @"alarm":model.alarm,
                          @"tags":model.tags,
                          @"content":model.content};
    
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
-(NSArray *)readAllSchedules{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"schedule.sqlite"];
    NSString *tableName = @"schedule";
    //数据
    NSDictionary *keyTypes = @{@"date":@"text",
                               @"schedule_id":@"integer",
                               @"name":@"text",
                               @"emergency":@"text",
                               @"start_time":@"text",
                               @"end_time":@"text",
                               @"address":@"text",
                               @"alarm":@"text",
                               @"tags":@"text",
                               @"content":@"text"};
    
    NSInteger limitNum = -1;
    //执行查询
    NSArray *result = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName limitNum:limitNum];
    //转模型
    NSMutableArray *modelResult = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ScheduleModel *model = [ScheduleModel modelWithDic:obj];
        [modelResult addObject:model];
    }];
    return modelResult;
}

//读取数据 --条件读取
-(NSArray *)readScheduleModelFromDBWhereCondition:(NSDictionary *)condition{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"schedule.sqlite"];
    NSString *tableName = @"schedule";
    //数据
    NSDictionary *keyTypes = @{@"date":@"text",
                               @"schedule_id":@"integer",
                               @"name":@"text",
                               @"emergency":@"text",
                               @"start_time":@"text",
                               @"end_time":@"text",
                               @"address":@"text",
                               @"alarm":@"text",
                               @"tags":@"text",
                               @"content":@"text"};
    
    NSInteger limitNum = -1;
    //执行查询
    NSArray *result = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName whereCondition:condition limitNum:limitNum];
    //转模型
    NSMutableArray *modelResult = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ScheduleModel *model = [ScheduleModel modelWithDic:obj];
        [modelResult addObject:model];
    }];
    return modelResult;
}

//读取数据 －模糊查询:标题
-(NSArray *)readScheduleModelWhereTitleNameLike:(NSString *)name{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"schedule.sqlite"];
    NSString *tableName = @"schedule";
    //数据
    NSDictionary *keyTypes = @{@"date":@"text",
                               @"schedule_id":@"integer",
                               @"name":@"text",
                               @"emergency":@"text",
                               @"start_time":@"text",
                               @"end_time":@"text",
                               @"address":@"text",
                               @"alarm":@"text",
                               @"tags":@"text",
                               @"content":@"text"};
    
    NSInteger limitNum = -1;
    //执行查询 - 模糊查询
    NSArray *result_begin = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName whereKey:@"name" beginWithStr:name limitNum:limitNum];
    NSArray *result_contain = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName whereKey:@"name" containStr:name limitNum:limitNum];
    NSArray *result_end = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName whereKey:@"name" endWithStr:name limitNum:limitNum];
    
    NSMutableSet *set = [NSMutableSet setWithArray:result_begin];
    
    [set addObjectsFromArray:result_contain];
    [set addObjectsFromArray:result_end];
    
    NSArray *result = [set allObjects];
    //转模型
    NSMutableArray *modelResult = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ScheduleModel *model = [ScheduleModel modelWithDic:obj];
        [modelResult addObject:model];
    }];
    return modelResult;
}
//读取数据 －模糊查询:标签
-(NSArray *)readScheduleModelWhereTagLike:(NSString *)tag{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"schedule.sqlite"];
    NSString *tableName = @"schedule";
    //数据
    NSDictionary *keyTypes = @{@"date":@"text",
                               @"schedule_id":@"integer",
                               @"name":@"text",
                               @"emergency":@"text",
                               @"start_time":@"text",
                               @"end_time":@"text",
                               @"address":@"text",
                               @"alarm":@"text",
                               @"tags":@"text",
                               @"content":@"text"};
    
    NSInteger limitNum = -1;
    //执行查询 - 模糊查询
    NSArray *result_begin = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName whereKey:@"tags" beginWithStr:tag limitNum:limitNum];
    NSArray *result_contain = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName whereKey:@"tags" containStr:tag limitNum:limitNum];
    NSArray *result_end = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName whereKey:@"tags" endWithStr:tag limitNum:limitNum];
    
    NSMutableSet *set = [NSMutableSet setWithArray:result_begin];
    
    [set addObjectsFromArray:result_contain];
    [set addObjectsFromArray:result_end];
    
    NSArray *result = [set allObjects];
    //转模型
    NSMutableArray *modelResult = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ScheduleModel *model = [ScheduleModel modelWithDic:obj];
        [modelResult addObject:model];
    }];
    return modelResult;
}
//读取数据 －精准查询:日期
-(NSArray *)readScheduleModelWhereStartDate:(NSString *)starDateStr andEndDate:(NSString *)endDateStr{
    NSDate *startDate = [NSDate dateWithString:starDateStr];
    NSDate *endDate = [NSDate dateWithString:endDateStr];
    NSTimeInterval start = [startDate timeIntervalSince1970];
    NSTimeInterval end = [endDate timeIntervalSince1970];
    
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"schedule.sqlite"];
    NSString *tableName = @"schedule";
    //数据
    NSDictionary *keyTypes = @{@"date":@"text",
                               @"schedule_id":@"integer",
                               @"name":@"text",
                               @"emergency":@"text",
                               @"start_time":@"text",
                               @"end_time":@"text",
                               @"address":@"text",
                               @"alarm":@"text",
                               @"tags":@"text",
                               @"content":@"text"};
    
    NSInteger limitNum = -1;
    //执行查询
    NSArray *result = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName limitNum:limitNum];
    //转模型
    NSMutableArray *modelResult = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ScheduleModel *model = [ScheduleModel modelWithDic:obj];
        NSDate *m_startDate;
        if (model.start_time.length > 14) {//@"yyyy-MM-dd HH:mm:ss"
            m_startDate = [NSDate dateWithString:model.start_time];
        }else{//@"yyyy-MM-dd EEE"]
            m_startDate = [NSDate dateWithAllDayString:model.start_time];
        }
        NSDate *m_endDate;
        if (model.end_time.length > 14) {//@"yyyy-MM-dd HH:mm:ss"
            m_endDate = [NSDate dateWithString:model.end_time];
        }else{//@"yyyy-MM-dd EEE"]
            m_endDate = [NSDate dateWithAllDayString:model.end_time];
        }
        NSTimeInterval m_start = [m_startDate timeIntervalSince1970];
        NSTimeInterval m_end = [m_endDate timeIntervalSince1970];
        //添加在选择的时间区间的model
        if ((m_start >= start && m_start <= end) || (m_end >= start && m_end <= end)) {
            [modelResult addObject:model];
        }
    }];
    return modelResult;
}
//读取数据 －精准查询:紧急程度
-(NSArray *)readScheduleModelWhereEmergencyLike:(NSString *)emergency{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"schedule.sqlite"];
    NSString *tableName = @"schedule";
    //数据
    NSDictionary *keyTypes = @{@"date":@"text",
                               @"schedule_id":@"integer",
                               @"name":@"text",
                               @"emergency":@"text",
                               @"start_time":@"text",
                               @"end_time":@"text",
                               @"address":@"text",
                               @"alarm":@"text",
                               @"tags":@"text",
                               @"content":@"text"};
    
    NSInteger limitNum = -1;
    //执行查询
    NSArray *result = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName whereCondition:@{@"emergency":emergency} limitNum:limitNum];
    //转模型
    NSMutableArray *modelResult = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ScheduleModel *model = [ScheduleModel modelWithDic:obj];
        [modelResult addObject:model];
    }];
    return modelResult;
}


//清除缓存 --全部数据
-(void)cleanDisk_schedule{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"schedule.sqlite"];
    NSString *tableName = @"schedule";
    //将数据库中的数据全部清除
    [manager clearDatabase:db from:tableName];
}

@end
