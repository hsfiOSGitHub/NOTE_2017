//
//  NSDate+hsfDateFormater.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/16.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (hsfDateFormater)

+(NSString *)hour24DateStringWithDate:(NSDate *)date;
+(NSString *)hour12DateStringWithDate:(NSDate *)date;
+(NSString *)yearMonthDayStringWithDate:(NSDate *)date;
+(NSString *)yearMonthDayWeekStringWithDate:(NSDate *)date;

@end
