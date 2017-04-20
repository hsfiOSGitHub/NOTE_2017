//
//  UMComNetworkConfig.h
//  UMCommunity
//
//  Created by 张军华 on 16/4/13.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UMComNetworkConfig : NSObject

/**
 *  微社区AppKey
 */
@property (nonatomic, copy, nonnull) NSString *appKey;

/**
 *  微社区AppSecret
 */
@property (nonatomic, copy, nonnull) NSString *appSecret;

/**
 *  http请求token
 *  @discuss 登出、切换appkey、切换用户需清理
 */
@property (nonatomic, copy, nullable) NSString *accessToken;

/**
 *  登录用户uid
 *  @discuss 登出、切换appkey、切换用户需清理
 */
@property (nonatomic, weak, nullable) NSString *uid;

/**
 *  imageUploadServerType表示要将图片上传到的服务器类型，默认值为0表示上传到阿里云百川服务器
 *  1 - 表示上传到友盟微社区服务器
 *  2 - 表示开发者自己的服务器（这些值可根据需要在友盟微社区后台设置，社区初始化的时候自动获取）
 *  @warning 如果设置值为2，则图片上传功能和逻辑需要开发者自己实现，开发者自己上传成功之后在将图片url上传到友盟微社区即可。
 */
@property (nonatomic, assign) NSInteger imageUploadServerType;

+ (instancetype __nonnull)sharedInstance;

/**
 *  设备基本信息
 *
 *  @return 包含HTTP URL参数的字典
 */
+ (NSDictionary * __nonnull)httpBaseInfoDictionary;

/**
 *  HTTP请求头信息
 *
 *  @return 包含HTTP header中token值的字典
 */
+ (NSDictionary * __nonnull)httpBaseHeader;

@end