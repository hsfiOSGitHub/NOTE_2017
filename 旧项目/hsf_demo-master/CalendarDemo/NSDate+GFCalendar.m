//
//  NSDate+GFCalendar.m
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import "NSDate+GFCalendar.h"

@implementation NSDate (GFCalendar)

//格式化时间
+(NSString *)starEndTimeWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSString *currentDateString = [formatter stringFromDate:date];

    return currentDateString;
}
+(NSString *)allDayTimeWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd EEE"];
    
    NSString *currentDateString = [formatter stringFromDate:date];
    
    return currentDateString;
}
+(NSString *)alarmTimeWithDate:(NSDate *)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"H小时 m分钟"];
    
    NSString *currentDateString = [formatter stringFromDate:date];
    
    return currentDateString;
}

//(字符串转化为日期)
+(NSDate *)dateWithString:(NSString *)string{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
//    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@en_US]];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *date = [formatter dateFromString:string];
    
    return date;
}
+(NSDate *)dateWithAllDayString:(NSString *)string{    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    //    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@en_US]];
    
    [formatter setDateFormat:@"yyyy-MM-dd EEE"];
    
    NSDate *date = [formatter dateFromString:string];
    
    return date;
}

//本周日期区间
+(NSString *)currentWeek:(NSDate *)date{
    NSInteger firstWeekDayInMonth = [date firstWeekDayInMonth];
    NSInteger num = firstWeekDayInMonth + [date dateDay];
    NSInteger remainder = num%7;
    NSInteger firstDayOfWeek = [date dateDay] - remainder;
    NSInteger lastDayOfWeek = [date dateDay] + (7 - remainder);
    NSString *currentWeek = [NSString stringWithFormat:@"%ld月%ld日 - %ld月%ld日",[date dateMonth], firstDayOfWeek, [date dateMonth], lastDayOfWeek];
    return currentWeek;
}



- (NSInteger)dateDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:self];
    return components.day;
}

- (NSInteger)dateMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:self];
    return components.month;
}

- (NSInteger)dateYear {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:self];
    return components.year;
}

- (NSDate *)previousMonthDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 15; // 定位到当月中间日子
    
    if (components.month == 1) {
        components.month = 12;
        components.year -= 1;
    } else {
        components.month -= 1;
    }
    
    NSDate *previousDate = [calendar dateFromComponents:components];
    
    return previousDate;
}

- (NSDate *)nextMonthDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 15; // 定位到当月中间日子
    
    if (components.month == 12) {
        components.month = 1;
        components.year += 1;
    } else {
        components.month += 1;
    }
    
    NSDate *nextDate = [calendar dateFromComponents:components];
    
    return nextDate;
}

- (NSInteger)totalDaysInMonth {
    NSInteger totalDays = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
    return totalDays;
}

- (NSInteger)firstWeekDayInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 1; // 定位到当月第一天
    NSDate *firstDay = [calendar dateFromComponents:components];
    
    // 默认一周第一天序号为 1 ，而日历中约定为 0 ，故需要减一
    NSInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDay] - 1;
    
    return firstWeekday;
}

@end
