//
//  ZXJiaoGOHelper.h
//  ZXJiaXiao
//
//  Created by ZX on 16/3/3.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
    提供工具接口
 */
@interface ZXDriveGOHelper : NSObject
//获得当前的时间戳
+ (NSString *)getCurrentTimeStamp;
//弹出一个警示框
+ (void)persentAlertView:(UIViewController *)viewController andMessage:(NSString *)message;
+ (void)persentAlertView:(UIViewController *)viewController andMessage:(NSString *)message andIsPopSelf:(BOOL)isPop;
//得到一个MD5字符串
+ (NSString *)getMD5StringWithString:(NSString *)string;

+ (NSString *)getCurrentDataTimeWithFormatter:(NSString *)formatter;

+ (NSString *)getUseTimeWithEarilerTime:(NSString *)earilerDate andLaterTime:(NSString *)laterDate andDateFormate:(NSString *)df;

@end
