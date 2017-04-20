//
//  NSString+dateString.h
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/28.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (dateString)

//日期转换为字符串 date －>  string
+(instancetype)dateStringWithDate:(NSDate *)date andFormaterString:(NSString *)formaterString;

@end
