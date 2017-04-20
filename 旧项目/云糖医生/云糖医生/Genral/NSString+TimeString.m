//
//  NSString+TimeString.m
//  yuntangyi
//
//  Created by yuntangyi on 16/10/17.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "NSString+TimeString.h"

@implementation NSString (TimeString)
/*处理返回应该显示的时间*/
+ (NSString *) returnUploadTime:(NSString*)timeStr
{
//    NSDateFormatter *date = [[NSDateFormatter alloc] init];
//    [date setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//    NSDate *d = [date dateFromString:timeStr];
//    NSTimeInterval late = [d timeIntervalSince1970]*1;
//    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
//    NSTimeInterval now = [dat timeIntervalSince1970]*1;
    NSString *timeString = @"";
//    NSTimeInterval cha = now - late;
//    
//    if (cha/60<1){
//        timeString = [NSString stringWithFormat:@"%.0f秒前", cha];
//    }else if (cha/60>=1 && cha/(60*60)<1){
//        timeString = [NSString stringWithFormat:@"%.0f分钟前", cha/60];
//    }else if (cha/(60*60)>1 && cha/(60*60*24)<1){
//        timeString = [NSString stringWithFormat:@"%.0f小时前",cha/3600];
//    }else if (cha/(60*60*24)>=1 && cha/(60*60*24*7)<1){
//        timeString = [NSString stringWithFormat:@"%.0f天前", cha/86400];
//    }else{
//        timeString = [timeStr substringToIndex:10];
//    }
    
//    if (cha/2592000>2) {
//        NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
//        [dateformatter setDateFormat:@"YYYY-MM-dd"];
//        timeString = [NSString stringWithFormat:@"%@",[dateformatter stringFromDate:d]];
//    }
    timeString = [timeStr substringToIndex:10];
    return timeString;
}
@end
