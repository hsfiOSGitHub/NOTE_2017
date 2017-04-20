//
//  ZXJiaoGOHelper.m
//  ZXJiaXiao
//
//  Created by ZX on 16/3/3.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXDriveGOHelper.h"
#import "NSString+Hashing.h"
@interface ZXDriveGOHelper()<UIAlertViewDelegate>
@end
@implementation ZXDriveGOHelper
+ (NSString *)getCurrentTimeStamp {
    
    NSString* str=@"";
    for (int i=0; i<32; i++)
    {
        str=[str stringByAppendingString:[NSString stringWithFormat:@"%u", arc4random()%10+1]];
    }
    return str;
}

+ (void)persentAlertView:(UIViewController *)viewController andMessage:(NSString *)message
{
    YZLog(@"%@",[UIDevice currentDevice].systemVersion);
    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0)
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alertView show];
    }
    else
    {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action];
    [viewController presentViewController:alertController animated:YES completion:nil];
}


}

+ (void)persentAlertView:(UIViewController *)viewController andMessage:(NSString *)message andIsPopSelf:(BOOL)isPop{
//    UIAlertAction *action;
//    if (isPop) {
//        if (viewController.navigationController) {
//            action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                [viewController.navigationController popViewControllerAnimated:YES];
//            }];
//        } else {
//            action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//
//        }
//        
//    } else {
//        action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
//    }
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
//    
//    [alertController addAction:action];
//    [viewController presentViewController:alertController animated:YES completion:nil];
//    
//    
//    if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
    ZXDriveGOHelper *helper = [[self alloc] init];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:message delegate:helper cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
//    }
}
+ (NSString *)getMD5StringWithString:(NSString *)string {
    return [string MD5Hash];
}

+ (NSString *)getCurrentDataTimeWithFormatter:(NSString *)formatter {
    NSDate *date = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = formatter;
    return [df stringFromDate:date];
    
}

//获得时间差
+ (NSString *)getUseTimeWithEarilerTime:(NSString *)earilerDate andLaterTime:(NSString *)laterDate andDateFormate:(NSString *)df{
    NSDateFormatter *dateformate = [[NSDateFormatter alloc] init];
    dateformate.dateFormat = df;
    NSDate *earilerTime = [dateformate dateFromString:earilerDate];
    NSDate *laterTime = [dateformate dateFromString:laterDate];
    NSTimeInterval diff = [earilerTime timeIntervalSinceDate:laterTime];
    
    return [NSString stringWithFormat:@"%f分",diff];
}

#pragma mark--
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

}

@end
