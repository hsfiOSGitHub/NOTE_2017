//
//  UMComKit.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/12/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComDataTypeDefine.h"
#import <UMComDataStorage/UMComUser.h>

/**
 *注册消息推送的别名
 */
extern NSString * kNSAliasKey;

@class UMComFeedEditDataController, UMComUnReadNoticeModel, UMComUser;

@interface UMComSession : NSObject

/**
 *  当前登录用户
 */
@property (nonatomic, strong) UMComUser *loginUser;

/**
 *  登录用户uid
 */
@property (nonatomic, readonly) NSString *uid;

/**
 *  登录状态
 */
@property (nonatomic, readonly) BOOL isLogin;

/**
 *  当前的社区是否为访客模式
 *  0: 未开通访客模式
 *  1: 开通访客模式
 * （需要在友盟微社区后台设置，社区初始化的时候自动获取）
 */
@property (nonatomic, assign) NSInteger communityGuestMode;


@property (nonatomic, strong) UMComFeedEditDataController *draftFeed;

/**
 unReadNoticeModel 表示未读消息数据模型（这个值需要在友盟微社区后台设置，社区初始化的时候自动获取或收到消息远程通知会自动获取）
 */
@property (nonatomic, strong) UMComUnReadNoticeModel *unReadNoticeModel;

/**
 maxFeedLength 表示Feed内容的最大长度， 默认为300（这个值需要在友盟微社区后台设置，社区初始化的时候自动获取）
 
 */
@property (nonatomic, assign, readonly) NSInteger maxFeedLength;

/**
 comment_length 表示Feed评论的最大长度， 默认为300（这个值需要在友盟微社区后台设置，社区初始化的时候自动获取）
 
 */
@property (nonatomic, assign, readonly) NSInteger comment_length;


+ (UMComSession *)sharedInstance;

/**
 *  调试日志
 *
 *  @param isLog YES-开启 NO-关闭
 */
+ (void)openLog:(BOOL)isLog;

/**
 *  获取访客模式
 */
- (void)requestGuestMode;

/**
 * 更新社区配置信息和未读消息数
 */
- (void)refreshConfigDataWithCompletion:(void (^)(NSDictionary *configData, NSError *error))completion;

/**
 *  用户登出，并清空数据库
 */
- (void)userLogout;


/**
 判断用户是否具有删除的权限
 
 @return 如果具备删除的权限则返回YES，否者返回NO
 */
- (BOOL)isPermissionDelete;

/**
 判断用户是否具有删除这个Feed的权限
 
 @param feed 删除的feed
 
 @return 如果具备删除的权限则返回YES，否者返回NO
 */
- (BOOL)isPermissionDeleteFeed:(id)feed;

/**
 判断用户是否具有删除这个评论的权限
 
 @param comment 删除的评论
 
 @return 如果具备删除的权限则返回YES，否者返回NO
 */
- (BOOL)isPermissionDeleteComment:(id)comment;


/**
 判断用户是否具有发公告的权限
 
 @return 如果具备发公告的权限则返回YES，否者返回NO
 */
- (BOOL)isPermissionBulletin;

/**
 * 检查是否可以举报用户user
 */
- (BOOL)isNeedSpamUser:(UMComUser *)user;


@end
