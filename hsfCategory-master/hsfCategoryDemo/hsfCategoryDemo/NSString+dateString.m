//
//  NSString+dateString.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/28.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "NSString+dateString.h"

@implementation NSString (dateString)

+(instancetype)dateStringWithDate:(NSDate *)date andFormaterString:(NSString *)formaterString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formaterString];
    NSString *currentDateString = [formatter stringFromDate:date];
    return currentDateString;
}

@end
