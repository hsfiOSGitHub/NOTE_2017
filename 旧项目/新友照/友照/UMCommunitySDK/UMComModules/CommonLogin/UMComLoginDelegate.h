//
//  UMComLoginDelegate.h
//  UMCommunity
//
//  Created by Gavin Ye on 11/11/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComResouceDefines.h"

typedef void(^LoginCompletion)(id responseObject, NSError *error);


@class UMComFeed, UMComLoginUser, UMComUser;

@protocol UMComLoginDelegate <NSObject>

@optional

/**
 设置自定义登录的Appkey
 
 */
- (void)setAppKey:(NSString *)appKey;


/**
 自定义登录或者自定义分享处理URL地址
 
 @param 应用回传的URL地址
 
 @returns 处理结果
 */
- (BOOL)handleOpenURL:(NSURL *)url;


/**
 处理自定义登录，在友盟微社区没有登录情况下点击遇到需要登录的按钮，就会触发此方法
 
 @param viewController 父ViewController
 @param LoadDataCompletion 登录完成的回调
 
 */
- (void)presentLoginViewController:(UIViewController *)viewController finishResponse:(LoginCompletion)completion;

- (void)handleLoginError:(NSError *)error inViewController:(UIViewController *)rootViewController withLoginData:(UMComLoginUser *)loginUser;

- (void)updateProfileInViewController:(UIViewController *)rootViewController withLoginData:(UMComLoginUser *)loginUser completion:(dispatch_block_t)completion;

- (void)handleEventAfterRegister:(UIViewController *)rootViewController completion:(dispatch_block_t)completion;

@end
