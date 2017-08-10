//
//  DevTongXieConfig.h
//  DevNotePageKit
//
//  Created by LoaforSpring on 15/5/27.
//  Copyright (c) 2015年 LoaforSpring. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


//MARK:批注平台类型
typedef NS_ENUM (NSInteger, DevPlatformType)
{
    Platform_Type_Default     = 1 << 1,// 普通应用App
    Platform_Type_Application = Platform_Type_Default,// 普通应用App
    Platform_Type_Unity3d     = 1 << 2,// 基于Unity3d开发的App
    Platform_Type_Cocos2d     = 1 << 3 ,// 基于Cocos2d开发的App
    Platform_Type_Cocos2dx    = 1 << 4,// 基于Cocos2dx开发的App
    Platform_Type_Sprite      = 1 << 5//
};

@interface DevTongXieConfig : NSObject

/**
 *  @brief 单例方法
 *
 *  @return 本类对象
 */
+(DevTongXieConfig *)sharedInstance;

/**
 *  @brief 释放对象
 */
+(void)currentRelease;

/**
 *  获取当前批注的应用类型
 *
 *  @return 应用类型
 */
- (DevPlatformType)getPlatformType;

/**
 *  开启批注
 */
+ (void)initializeDevComment;

/**
 *  当网络异常时，重校验批注认证信息
 */
- (void)reverifyIClapSDKAppkeyAndSecret;

/**
 *  校验申请的身份令牌信息
 *
 *  @param appkey 身份令牌
 *  @param secret 加密字符
 */
- (void)initIClapSDKWithAppkey:(NSString *)appkeyStr secret:(NSString *)secretStr;

/**
 *  校验申请的身份令牌信息
 *
 *  @param appkey       身份令牌
 *  @param secret       加密字符
 *  @param platformType 批注类型
 */
- (void)initIClapSDKWithAppkey:(NSString *)appkeyStr secret:(NSString *)secretStr hookType:(DevPlatformType)platformType;

- (void)devRegisterForRemoteNotifications;
- (void)devRegisterForRemoteNotifications2;
/**
 *  向iClap推送服务器提交device token注册请求，只有在注册deviceToken后才可以绑定
 *
 *  @param deviceToken 通过 AppDelegate 中的 didRegisterForRemoteNotificationsWithDeviceToken 回调获取
 */
- (void)devDidRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;

/**
 *  程序关闭时接收到推送消息
 *
 *  @param launchOptions 消息体
 */
- (void)devDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/**
 *  程序在后台运行时接收到推送消息
 *
 *  @param userInfo 消息体
 */
- (void)devDidReceiveRemoteNotification:(NSDictionary *)userInfo;

- (void)testNotification:(NSInteger)type aboudData:(NSString *)aboutData;

- (void)hlApplication:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification;

@end
