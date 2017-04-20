//
//  UMComLoginManager.h
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComLoginUser.h"
#import "UMComLoginDelegate.h"
#import <UMCommunitySDK/UMComDataRequestManager.h>


@interface UMComLoginManager : NSObject

@property (nonatomic, strong) id<UMComLoginDelegate> loginHandler;


+ (UMComLoginManager *)shareInstance;


/**
 * 获取当前是否登录
 */
+ (BOOL)isLogin;

/**
 * 提供社区SDK调用，默认使用友盟登录SDK，或者自定义的第三方登录SDK，实现登录功能
 */
+ (void)performLogin:(UIViewController *)viewController completion:(void (^)(id responseObject, NSError *error))completion;

/**
 * 用户注销方法
 * @warning 调用这个方法退出登录同时会清空数据库（在没登陆的情况下慎重调用）
 */

+ (void)userLogout;

/**
 处理SSO跳转回来之后的url
 
 */
+ (BOOL)handleOpenURL:(NSURL *)url;

@end


@interface UMComLoginManager (LoginRequest)

/**
 *  向server发送登录请求的回调
 *
 *  @param responseObject     登录结构
 *  @param error              错误信息
 *  @param callbackCompletion 当登录成功后(即error为空)，登录页面dismiss动画结束后回调
 */
typedef void (^UMComLoginCompletion)(NSDictionary *responseObject, NSError *error, dispatch_block_t callbackCompletion);

/**
 *  用户登录请求：第三方或自有用户系统
 *
 *  @param userAccount 用户信息
 *  @param completion  请求完成回调
 */
+ (void)requestLoginWithLoginAccount:(UMComLoginUser *)userAccount requestCompletion:(UMComLoginCompletion)completion;

/**
 *  用户登录请求：使用微社区用户系统
 *
 *  @param emailAccount 邮箱账号
 *  @param password     密码
 *  @param completion   请求完成回调
 */
+ (void)requestLoginWithEmailAccount:(NSString *)emailAccount password:(NSString *)password requestCompletion:(UMComLoginCompletion)completion;

/**
 *  用户注册请求：使用微社区用户系统
 *
 *  @param emailAccount 邮箱账号
 *  @param password     密码
 *  @param nickName     昵称
 *  @param completion   请求完成回调
 */
+ (void)requestRegisterWithEmailAccount:(NSString *)emailAccount password:(NSString *)password nickName:(NSString *)nickName requestCompletion:(UMComLoginCompletion)completion;

@end

