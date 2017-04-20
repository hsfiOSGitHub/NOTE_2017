//
//  ZXwangLuoDanLi.m
//  ZXJiaXiao
//
//  Created by caoyujian on 16/7/15.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXwangLuoDanLi.h"
@implementation ZXwangLuoDanLi


+ (instancetype)WangLuoDanLi
{
    static ZXwangLuoDanLi *_S = nil;
    @synchronized (self)
    {
        if (_S == nil)
        {
            _S = [[ZXwangLuoDanLi alloc] init];
        }
    }
    return _S;
}
//判断服务器返回值
- (BOOL)resIsTrue:(NSDictionary *)dict andAlertView:(UIViewController *)alertVC
{
    YZLog(@"%@",dict[@"res"]);
    if ([dict[@"res"] isEqualToString:@"1001"])
    {
        return YES;
    }
    else if ([dict[@"res"] isEqualToString:@"1002"])
    {
        [ZXUD setBool:NO forKey:@"IS_LOGIN"];
        [ZXUD synchronize];        
        //移除掉用户的数据
        [ZXUD removeObjectForKey:@"userpic"];
        [ZXUD removeObjectForKey:@"username"];
        [ZXUD removeObjectForKey:@"phoneNum"];
        [ZXUD synchronize];
        return NO;
    }
    else
    {
        [MBProgressHUD showSuccess:dict[@"msg"]];
        return NO;
    }
}
@end
