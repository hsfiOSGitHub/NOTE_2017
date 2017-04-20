//
//  NSDate+dateString.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/28.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "NSDate+dateString.h"

@implementation NSDate (dateString)

//日期转换为字符串 date －>  string
+(instancetype)dateWithDateString:(NSString *)dateString andFormaterString:(NSString *)formaterString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
//    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@en_US]];
    
    [formatter setDateFormat:formaterString];
    
    NSDate *date = [formatter dateFromString:dateString];
    
    return date;
}


@end
