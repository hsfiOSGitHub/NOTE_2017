//
//  HSFFmdbManager+task.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/10.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "HSFFmdbManager.h"

@interface HSFFmdbManager (task)

//添加数据
-(void)insertNewTask:(TaskModel *)model;

//删除数据 --条件删除
-(void)deleteTaskWhereCondition:(NSDictionary *)condition;

//数据修改 --条件修改
-(void)modifyTaskWith:(TaskModel *)model whereCondition:(NSDictionary *)condition;

//读取数据 --全部数据
-(NSArray *)readAllTasks;

//读取数据 --条件读取
-(NSArray *)readTaskModelFromDBWhereCondition:(NSDictionary *)condition;

//清除缓存 --全部数据
-(void)cleanDisk_Task;

@end
