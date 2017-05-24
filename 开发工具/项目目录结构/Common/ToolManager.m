//
//  ToolManager.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "ToolManager.h"

#import <sys/utsname.h>

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
/*
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
 */

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


//点击退出当前账号
-(void)logoutACTIONFromSuperVC:(UIViewController *)superVC{
    [kUserDefaults setObject:@"0" forKey:@"token"];
    [kUserDefaults synchronize];
    //跳转到登录界面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        LoginVC *login_VC = [[LoginVC alloc]init];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login_VC];
        [superVC presentViewController:navi animated:YES completion:nil];
    });
}



/**
 *  获取当前时间
 *
 *  @return 当前时间
 */
- (NSString *)getCurrentTime{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM月dd日HH:mm"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}
/**
 *  数组逆序
 *
 *  @param array 需要逆序的数组
 *
 *  @return 逆序后的输出
 */
- (NSMutableArray *)exchangeArray:(NSMutableArray *)array{
    NSInteger num = array.count;
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    for (NSInteger i = num - 1; i >= 0; i --) {
        [temp addObject:[array objectAtIndex:i]];
        
    }
    return temp;
}


//判断手机型号
- (NSString *)iphoneType {
    
//    需要导入头文件：#import <sys/utsname.h>
    
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
    
}




@end
