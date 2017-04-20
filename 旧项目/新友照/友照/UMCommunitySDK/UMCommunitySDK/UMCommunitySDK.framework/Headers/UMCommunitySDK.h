//
//  UMCommunitySDK.h
//  UMCommunitySDK
//
//  Created by wyq.Cloudayc on 7/25/16.
//  Copyright © 2016 umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * _Nonnull kUMComUpdateAppKeyNotification;


@interface UMCommunitySDK : NSObject

/**
 *  微社区appKey
 *
 *  @return 微社区appKey
 */
+ (NSString * __nonnull)appKey;

/**
 *  微社区appSecret
 *
 *  @return 微社区appSecret
 */
+ (NSString * __nonnull)appSecret;

/**
 *  初始化微社区
 *
 *  @param appkey    微社区AppKey
 *  @param appSecret 微社区AppSecret
 */
+ (void)setAppkey:(NSString * __nonnull)appkey withAppSecret:(NSString * __nonnull)appSecret;



@end
