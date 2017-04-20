//
//  UMComTools.m
//  UMCommunity
//
//  Created by luyiyuan on 14/10/9.
//  Copyright (c) 2014年 Umeng. All rights reserved.
//

#import "UMComResouceDefines.h"

/*2.4版本的时间显示*/
static NSCalendar* g_UMCalendar = nil;
static NSCalendar* g_UMCurrentCalendar = nil;
NSString* const g_UMNullDateFormat = @"";
NSString* const g_UMFullDateFormat = @"yyyy-MM-dd HH:mm:ss";
NSString* const g_UMTodayDateFormat = @"HH:mm";
NSString* const g_UMCurYearDateFormat = @"MM-dd";
NSString* const g_UMBeforeCurYearDateFormat = @"yy-MM-dd";
NSString* const g_UMAfterCurYearDateFormat = @"yy-MM-dd";
NSString* const g_UMYesteday = @"昨天";

NSString* createTimeString(NSString * create_time)
{
    if (![create_time isKindOfClass:[NSString class]] || create_time.length == 0) {
        return g_UMNullDateFormat;
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    if (!g_UMCalendar) {
        g_UMCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    [dateFormatter setCalendar:g_UMCalendar];
    [dateFormatter setDateFormat:g_UMFullDateFormat];
    NSDate *createDate= [dateFormatter dateFromString:create_time];
    if (createDate == nil) {
        return g_UMNullDateFormat;
    }
    
    if (!g_UMCurrentCalendar) {
        g_UMCurrentCalendar = [NSCalendar currentCalendar];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        if (zone) {
            g_UMCurrentCalendar.timeZone = zone;
        }
    }
    
    //当前的时间
    NSDate *today = [NSDate date];
    
    NSDateComponents *todayComponents = [g_UMCurrentCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:today];
    
    NSDateComponents *createComponents = [g_UMCurrentCalendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:createDate];
    if (!todayComponents || !createComponents) {
        return g_UMNullDateFormat;
    }
    
    //计算创建时间的段一个月的最大天数
    NSRange createDateMaxDaysInCurMonth = [g_UMCurrentCalendar rangeOfUnit:NSDayCalendarUnit
                                                                    inUnit:NSMonthCalendarUnit
                                                                   forDate:createDate];
    if (createDateMaxDaysInCurMonth.length == NSNotFound) {
        //如果计算不出来当前的最大值，说明字符串给出的时间格式或者日期有问题
        return g_UMNullDateFormat;
    }
    
    
    NSString* reslutString = g_UMNullDateFormat;
    NSInteger yearsOffsetSinceNow =  createComponents.year - todayComponents.year;
    if (yearsOffsetSinceNow > 0) {
        //创建时间大于当前的时间，此处就直接显示日期(yy-MM-dd)
        [dateFormatter setDateFormat:g_UMAfterCurYearDateFormat];
        reslutString = [dateFormatter stringFromDate:createDate];
    }
    else if (yearsOffsetSinceNow == 0)
    {
        //在当年
        NSInteger monthOffsetSinceNow = createComponents.month - todayComponents.month;
        if (monthOffsetSinceNow > 0) {
            //创建时间大于当前的时间，此处就直接显示日期(yy-MM-dd)
            [dateFormatter setDateFormat:g_UMAfterCurYearDateFormat];
            reslutString = [dateFormatter stringFromDate:createDate];
        }
        else if (monthOffsetSinceNow == 0)
        {
            //在当月
            NSInteger dayOffsetSinceNow = createComponents.day - todayComponents.day;
            if (dayOffsetSinceNow > 0) {
                //创建时间大于当前的时间，此处就直接显示日期(yy-MM-dd)
                [dateFormatter setDateFormat:g_UMAfterCurYearDateFormat];
                reslutString = [dateFormatter stringFromDate:createDate];
            }
            else if (dayOffsetSinceNow == 0)
            {
                //今天（HH:mm）
                [dateFormatter setDateFormat:g_UMTodayDateFormat];
                reslutString = [dateFormatter stringFromDate:createDate];
            }
            else if (dayOffsetSinceNow == -1)
            {
                //昨天（昨天 HH:mm）
                [dateFormatter setDateFormat:g_UMTodayDateFormat];
                NSString* tempString = [dateFormatter stringFromDate:createDate];
                if (!tempString) {
                    return reslutString;
                }
                
                //2.5版的时间函数显示（昨天 HH:mm）
                //reslutString = [NSString stringWithFormat:@"昨天%@",tempString];
                
                //2.6版本的时间函数显示 （昨天）
                reslutString = g_UMYesteday;
            }
            else
            {
                //今年（MM-dd）
                [dateFormatter setDateFormat:g_UMCurYearDateFormat];
                reslutString = [dateFormatter stringFromDate:createDate];
            }
        }
        else
        {
            if ((monthOffsetSinceNow == -1) &&
                (createDateMaxDaysInCurMonth.length == createComponents.day) && todayComponents.day == 1) {
                
                //昨天（昨天 HH:mm）
                [dateFormatter setDateFormat:g_UMTodayDateFormat];
                NSString* tempString = [dateFormatter stringFromDate:createDate];
                if (!tempString) {
                    return reslutString;
                }
                //2.5版的时间函数显示（昨天 HH:mm）
                //reslutString = [NSString stringWithFormat:@"昨天%@",tempString];
                
                //2.6版本的时间函数显示 （昨天）
                reslutString = g_UMYesteday;
            }
            else
            {
                //今年（MM-dd）
                [dateFormatter setDateFormat:g_UMCurYearDateFormat];
                reslutString = [dateFormatter stringFromDate:createDate];
            }
        }
    }
    else
    {
        //在去年或者以前的某一天
        if ((yearsOffsetSinceNow == -1) &&
            (createComponents.day == createDateMaxDaysInCurMonth.length) &&
            (createComponents.month == 12)&&(todayComponents.month == 1) && (todayComponents.day == 1))
        {
            //昨天（昨天 HH:mm）
            [dateFormatter setDateFormat:g_UMTodayDateFormat];
            NSString* tempString = [dateFormatter stringFromDate:createDate];
            if (!tempString) {
                return reslutString;
            }
            
            //2.5版的时间函数显示（昨天 HH:mm）
            //reslutString = [NSString stringWithFormat:@"昨天%@",tempString];
            
            //2.6版本的时间函数显示 （昨天）
            reslutString = g_UMYesteday;
        }
        else
        {
            //往年(yy-MM-dd)
            [dateFormatter setDateFormat:g_UMBeforeCurYearDateFormat];
            reslutString = [dateFormatter stringFromDate:createDate];
        }
    }
    
    return reslutString;
}

NSString *countString(NSNumber *count)
{
    if (![count isKindOfClass:[NSNumber class]]) {
        return @"";
    }
    
    NSInteger displayCount = [count integerValue];
    NSString *countString = @"";
    if (displayCount >= 10000) {
        NSInteger highestNum = displayCount/10000;
        if (displayCount < 11000) {
            countString = [NSString stringWithFormat:@"1W"];
        }else if (displayCount < 100000){
            NSInteger secondNum = (displayCount - 10000 *highestNum)/1000;
            if (secondNum == 0) {
                countString = [NSString stringWithFormat:@"%ldW",highestNum];
            }else{
                countString = [NSString stringWithFormat:@"%ld.%ldW",highestNum,secondNum];
            }
        }else if (displayCount < 100000000){
            countString = [NSString stringWithFormat:@"%ldW",highestNum];
        }else{
            countString = [NSString stringWithFormat:@"9999W"];
        }
    }
    else if (displayCount > 0){
        countString = [NSString stringWithFormat:@"%ld",displayCount];
    }
    else{
        countString = @"0";
    }
    return countString;
}

extern NSString *distanceString(NSNumber *distance)
{
    NSInteger displayCount = [distance integerValue];
    NSString *countString = @"";
    if (displayCount >= 1000) {
        NSInteger highestNum = displayCount/1000;
       if (displayCount < 10000){
            NSInteger secondNum = (displayCount - 1000 *highestNum)/100;
            countString = [NSString stringWithFormat:@"%ld.%ldkm",highestNum,secondNum];
        }else{
            countString = [NSString stringWithFormat:@"10km+"];
        }
    }else{
        countString = [NSString stringWithFormat:@"%ldm",displayCount];
    }
    return countString;
}
