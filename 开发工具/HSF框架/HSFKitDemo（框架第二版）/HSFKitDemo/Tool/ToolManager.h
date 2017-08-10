//
//  ToolManager.h
//  yuntangyi
//
//  Created by yuntangyi on 16/8/29.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolManager : NSObject




+(instancetype)sharedManager;

//获得当前的时间戳 + 随机数
+ (NSString *)getCurrentTimeStamp;
//MD5加密
+ (NSString *)secureMD5WithString:(NSString *)string;
//获取版本号
+ (NSString *)getVersion;
//判断手机型号
- (NSString *)iphoneType;
//获取当前时间str
- (NSString *)getCurrentTimeStrWithFormatterString:(NSString *)formatterString;

/**
 *  计算一个view相对于屏幕(去除顶部statusbar的20像素)的坐标
 *  iOS7下UIViewController.view是默认全屏的，要把这20像素考虑进去
 */
+ (CGRect)relativeFrameForScreenWithView:(UIView *)v;


//label的闪烁
- (void)shimmerHeaderTitle:(UILabel *)title;

//点击退出当前账号
-(void)logoutACTIONFromSuperVC:(UIViewController *)superVC;


@end
