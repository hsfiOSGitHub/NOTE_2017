//
//  NSDate+hsfDateFormater.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/16.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "NSDate+hsfDateFormater.h"

@implementation NSDate (hsfDateFormater)

+(NSString *)hour24DateStringWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *currentDateString = [formatter stringFromDate:date];
    return currentDateString;
}
+(NSString *)hour12DateStringWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"aa hh:mm"];
    NSString *currentDateString = [formatter stringFromDate:date];
    return currentDateString;
}
+(NSString *)yearMonthDayStringWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDateString = [formatter stringFromDate:date];
    return currentDateString;
}
+(NSString *)yearMonthDayWeekStringWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日EEE"];
    NSString *currentDateString = [formatter stringFromDate:date];
    return currentDateString;
}

@end
