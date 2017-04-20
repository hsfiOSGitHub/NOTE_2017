//
//  ScheduleModel.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/4.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ScheduleModel.h"

@implementation ScheduleModel

-(instancetype)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.date = dic[@"date"];
        self.schedule_id = dic[@"schedule_id"];
        self.name = dic[@"name"];
        self.emergency = dic[@"emergency"];
        self.start_time = dic[@"start_time"];
        self.end_time = dic[@"end_time"];
        self.address = dic[@"address"];
        self.alarm = dic[@"alarm"];
        self.tags = dic[@"tags"];
        self.content = dic[@"content"];
    }
    return self;
}
+(instancetype)modelWithDic:(NSDictionary *)dic{
    return [[self alloc]initWithDic:dic];
}

@end
