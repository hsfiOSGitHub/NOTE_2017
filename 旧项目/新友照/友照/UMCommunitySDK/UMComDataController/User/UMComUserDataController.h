//
//  UMComUserDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMCommunitySDK/UMComDataRequestManager.h>

@class UMComUser;

@interface UMComUserDataController : NSObject



@property (nonatomic, strong) UMComUser *user;

+ (UMComUserDataController *)userDataControllerWithUser:(UMComUser *)user;

+ (void)getUserWithUserID:(NSString *)userID completion:(UMComDataRequestCompletion)completion;

/**
 *  获得用户的基本信息
 *  @param completion 回调
 */
- (void)fetchUserProfileCompletion:(UMComDataRequestCompletion)completion;


/**
 *关注或取消关注用户
 */
- (void)followOrDisFollowUserCompletion:(UMComDataRequestCompletion)completion;

/**
 * 举报用户
 */
- (void)spamUserCompletion:(UMComDataRequestCompletion)completion;

/**
 * 禁言用户
 */
- (void)banUserWithTopics:(NSArray *)topics completion:(UMComDataRequestCompletion)completion;

/**
 * 建立私信
 */
- (void)creatChartBoxWithCompletion:(UMComDataRequestCompletion __nullable)completion;

/**
 * 发送私信消息
 */
- (void)sendUserPrivateMessage:(NSString *)content completion:(UMComDataRequestCompletion __nullable)completion;

@end
