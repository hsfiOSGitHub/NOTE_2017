//
//  TaskModel.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/10.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.date = dic[@"date"];
        self.task_id = dic[@"task_id"];
        self.title = dic[@"title"];
        self.time = dic[@"time"];
        self.isFinished = dic[@"isFinished"];
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

@end
