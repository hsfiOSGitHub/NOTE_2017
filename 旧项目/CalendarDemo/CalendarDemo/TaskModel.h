//
//  TaskModel.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/10.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaskModel : NSObject

@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSNumber *task_id;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *time;
@property (nonatomic,strong) NSString *isFinished;


-(instancetype)initWithDic:(NSDictionary *)dic;
+(instancetype)modelWithDic:(NSDictionary *)dic;

@end
