//
//  NSDate+GFCalendar.h
//
//  Created by Mercy on 2016/11/9.
//  Copyright © 2016年 Mercy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (GFCalendar)

//格式化时间(日期转化为字符串)  （用于日程的编辑页面）
+(NSString *)starEndTimeWithDate:(NSDate *)date;
+(NSString *)allDayTimeWithDate:(NSDate *)date;
+(NSString *)alarmTimeWithDate:(NSDate *)date;
//(字符串转化为日期)
+(NSDate *)dateWithString:(NSString *)string;
+(NSDate *)dateWithAllDayString:(NSString *)string;

//本周日期区间
+(NSString *)currentWeek:(NSDate *)date;


/**
 *  获得当前 NSDate 对象对应的日子
 */
- (NSInteger)dateDay;

/**
 *  获得当前 NSDate 对象对应的月份
 */
- (NSInteger)dateMonth;

/**
 *  获得当前 NSDate 对象对应的年份
 */
- (NSInteger)dateYear;

/**
 *  获得当前 NSDate 对象的上个月的某一天（此处定为15号）的 NSDate 对象
 */
- (NSDate *)previousMonthDate;

/**
 *  获得当前 NSDate 对象的下个月的某一天（此处定为15号）的 NSDate 对象
 */
- (NSDate *)nextMonthDate;

/**
 *  获得当前 NSDate 对象对应的月份的总天数
 */
- (NSInteger)totalDaysInMonth;

/**
 *  获得当前 NSDate 对象对应月份当月第一天的所属星期
 */
- (NSInteger)firstWeekDayInMonth;

@end
