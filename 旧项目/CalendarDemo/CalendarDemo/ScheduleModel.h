//
//  ScheduleModel.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/4.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScheduleModel : NSObject

@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSNumber *schedule_id;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *emergency;
@property (nonatomic,strong) NSString *start_time;
@property (nonatomic,strong) NSString *end_time;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *alarm;
@property (nonatomic,strong) NSString *tags;
@property (nonatomic,strong) NSString *content;


-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end
