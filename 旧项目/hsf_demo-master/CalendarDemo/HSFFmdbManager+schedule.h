//
//  HSFFmdbManager+schedule.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/4.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "HSFFmdbManager.h"

@interface HSFFmdbManager (schedule)

//添加数据
-(void)insertNewSchedule:(ScheduleModel *)model;

//删除数据 --条件删除
-(void)deleteScheduleWhereCondition:(NSDictionary *)condition;

//数据修改 --条件修改
-(void)modifyScheduleWith:(ScheduleModel *)model whereCondition:(NSDictionary *)condition;

//读取数据 --全部数据
-(NSArray *)readAllSchedules;

//读取数据 --条件读取
-(NSArray *)readScheduleModelFromDBWhereCondition:(NSDictionary *)condition;

//读取数据 －模糊查询:标题
-(NSArray *)readScheduleModelWhereTitleNameLike:(NSString *)name;
//读取数据 －模糊查询:标签
-(NSArray *)readScheduleModelWhereTagLike:(NSString *)tag;
//读取数据 －精准查询:日期
-(NSArray *)readScheduleModelWhereStartDate:(NSString *)starDate andEndDate:(NSString *)endDate;
//读取数据 －精准查询:紧急程度
-(NSArray *)readScheduleModelWhereEmergencyLike:(NSString *)emergency;

//清除缓存 --全部数据
-(void)cleanDisk_schedule;

@end
