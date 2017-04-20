//
//  UMComUserListDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"

@class UMComUser, UMComTopic;
/**
 * 用户相关列表DataController
 */
@interface UMComUserListDataController : UMComListDataController

/**
 *关注或取消关注用户
 */
- (void)followOrDisFollowUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion;

//定义一个当前UMComUserListDataController的基类对应的uid
@property(nonatomic,strong)NSString* uid;
@end

/**
 * 用户粉丝列表
 */
@interface UMComUserFansDataController : UMComUserListDataController

/**
 *用户
 */
@property (nonatomic, strong) UMComUser *user;

+ (UMComUserFansDataController *)userFansDataControllerWithUser:(UMComUser*)user count:(NSInteger)count;

@end


/**
 *用户关注的人列表
 */
@interface UMComUserFollowingDataController : UMComUserListDataController

/**
 *用户
 */
@property (nonatomic, strong) UMComUser *user;

+ (UMComUserFollowingDataController *)userFollowingDataControllerWithUser:(UMComUser*)user count:(NSInteger)count;

@end

/**
 *推荐用户列表
 */
@interface UMComUserRecommendDataController : UMComUserListDataController


@end

/**
 *话题下活跃用户
 */
@interface UMComUserTopicHotDataController : UMComUserListDataController

/**
 *活跃用户所在的话题
 */
@property (nonatomic, strong) UMComTopic *topic;

@end

/**
 *附近用户
 */
@interface UMComUserNearbyDataController : UMComUserListDataController

- (instancetype)initWithCount:(NSInteger)count location:(CLLocation*)location;

/**
 *当前位置
 */
@property (nonatomic, strong) CLLocation *location;

@end


/**
 *  搜索用户关键字
 */
@interface UMComSearchUserListDataController : UMComUserListDataController

- (instancetype)initWithCount:(NSInteger)count keyWord:(NSString*)keyWord;

@property(nonatomic,copy)NSString* keyWord;
@end


