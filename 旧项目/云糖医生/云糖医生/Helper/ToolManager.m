//
//  ToolManager.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "ToolManager.h"

@implementation ToolManager

static ToolManager *manager;
//单例的创建
+(instancetype)sharedManager{
    if (!manager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            manager = [[ToolManager alloc]init];
        });
    }
    return manager;
}

//获得当前的时间戳
+ (NSString *)getCurrentTimeStamp {
    NSDate *date = [NSDate date];
    NSTimeInterval timeStamp = [date timeIntervalSince1970];
    return [NSString stringWithFormat:@"%d",(int)timeStamp + arc4random() % 1000];
    
}
//加密
+ (NSString *)secureMD5WithString:(NSString *)string {
    const char *cStr = [string UTF8String];
    unsigned long length = strlen(cStr);
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)length, result);
    
    NSMutableString *secureString = [NSMutableString string];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [secureString appendFormat:@"%02X", result[i]];
    }
    return secureString;
}
//获得版本号
+ (NSString *)getVersion {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return currentVersion;
}
//获取当前日期
+ (NSString *)getCurrentDate {
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return [formatter stringFromDate:date];
}

@end
