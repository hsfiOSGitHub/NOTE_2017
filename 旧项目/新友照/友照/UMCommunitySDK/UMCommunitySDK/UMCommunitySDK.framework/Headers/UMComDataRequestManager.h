//
//  UMComDataAPIManager.h
//  UMCommunity
//
//  Created by umeng on 16/3/15.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMComNetwork/UMComHttpManager.h>
#import <UMComDataStorage/UMComDataBasePublicHeader.h>

/**
 feed的评论列表排序类型
 
 */
typedef enum {
    UMComRequestType_FocusedFeed = 0,//我关注的Feed请求类型
    UMComRequestType_RecommendFeed,//推荐Feed请求类型
    UMComRequestType_RealTimeHotFeed,//实时Feed请求类型
    UMComRequestType_RealTimeFeed,//实时Feed请求类型
    UMComRequestType_CommunityHotFeed,//社区热门Feed请求
    UMComRequestType_UserTimeLineFeed,//用户发布的Feed请求类型
    UMComRequestType_UserBaAtFeed,//@我的Feed请求类型
    UMComRequestType_UserFriendsFeed,//我的好友圈的Feed的请求类型
    UMComRequestType_UserFavoriteFeed,//我的收藏的Feed请求类型
    UMComRequestType_SurroundingFeed,//附近的Feed请求类型
    UMComRequestType_CoummunitySearchFeed,//搜索社区的Feed请求类型
    UMComRequestType_TopicLatesReleaseFeed,//话题下最新发布的Feed请求类型
    UMComRequestType_TopicHottestFeed,//话题下最热的Feed请求类型
    UMComRequestType_TopicLatesCommentFeed,//话题下最新评论的Feed请求类型
    UMComRequestType_TopicRecommendFeed,//话题下推荐的Feed请求类型
    UMComRequestType_FeedWithTopicID,//单独话题下的feed

    UMComRequestType_UserFollowsUser,//用户关注的人请求类型
    UMComRequestType_UserFansUser,//用户粉丝的请求类型
    UMComRequestType_RecommentUser,//推荐用户的请求类型
    UMComRequestType_SurroundingUser,//附近的人请求类型
    UMComRequestType_TopicActiveUser,//话题下活跃用户请求类型
    UMComRequestType_FriendListUser,//好友列表请求类型
    UMComRequestType_SearchFriendListUser,//好友列表请求类型

    UMComRequestType_TopicGroups,//话题组列表的请求类型

    UMComRequestType_AllTopic,//所有话题的请求类型
    UMComRequestType_RecommendTopic,//推荐的话题列表的请求类型
    UMComRequestType_FocusedTopic,//我关注的话题的请求类型
    UMComRequestType_GroupsTopic,//话题组下的话题列表的请求类型

    UMComRequestType_FeedComment,//Feed下的评论的请求类型
    UMComRequestType_UserReceiveComment,//收到的评论的请求类型
    UMComRequestType_UserSendComment,//发出的评论列表的请求类型

    UMComRequestType_FeedLike,//Feed下的点赞记录的请求类型
    UMComRequestType_UserReceiveLike,//用户收到的赞的请求类型
    UMComRequestType_UserSendLike,//用户点赞记录的请求类型

    UMComRequestType_PrivateLetter,//私信列表的请求类型
    UMComRequestType_PrivateMessage,//私信聊天记录的请求类型

    UMComRequestType_CommunityNotification,//用户收到的社区通知列表的请求类型

    UMComRequestType_UserAlbum,//用户相册的请求类型
    
    UMComRequestType_Location,//根据用户通过系统定位location来向服务器请求位置的中文信息
    
}UMComPageRequestType;


///获得用户的请求界面对应关系表的枚举类型，用来缓存对应接口数据的reltaionID
extern UMComRelatedIDTableType g_relatedIDTableTypeFromPageRequestType(UMComPageRequestType pageRequestType);

/**
 *接口统一使用的回调
 */
typedef void (^UMComRequestCompletion)(NSDictionary *responseObject, NSError *error);

/**
 * 网络数据统一回调
 */
typedef void (^UMComDataRequestCompletion)(id responseObject, NSError *error);



@protocol UMComDataLocalPersistenceHandleDelegate;


@interface UMComDataRequestManager : NSObject

@property (nonatomic, strong) id<UMComDataLocalPersistenceHandleDelegate> dataStoreDelegate;

+ (UMComDataRequestManager *)defaultManager;


/** 
 * 获取下一页请求
 *
 * @param urlString 下一页请求的url
 * @param pageRequestType 请求类型，参考枚举 'UMComPageRequestType'
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchNextPageWithNextPageUrl:(NSString *)urlString
                     pageRequestType:(UMComPageRequestType)pageRequestType
                          completion:(UMComRequestCompletion)completion;


#pragma mark - user

/** 
 * 获取某个用户的详细信息
 *
 * @param uid 用户的ID
 * @param source 平台名称
 * @param source_uid 所在平台用户ID
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchUserProfileWithUid:(NSString *)uid
                         source:(NSString *)source
                     source_uid:(NSString *)source_uid
                     completion:(UMComRequestCompletion)completion;



/** 
 * 开发者自有账号登录
 *
 * @param name 用户名 (必选， 但是只有第一次登录有效)
 * @param sourceId 平台用户ID（必选）
 * @param icon_url 用户头像地址(可选， 只有第一次登录有效)
 * @param gender 性别(可选， 只有第一次登录有效)
 * @param age 年龄(可选， 只有第一次登录有效)
 * @param custom 自定义字段(可选， 只有第一次登录有效)
 * @param score 积分(可选， 只有第一次登录有效)
 * @param levelTitle 等级title (可选， 只有第一次登录有效)
 * @param level 等级(可选， 只有第一次登录有效)
 * @param userNameType 用户名规则类型,参考枚举 'UMComUserNameType'
 * @param userNameLength 用户名长度规范，参考枚举 'UMComUserNameLength'
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)userCustomAccountLoginWithName:(NSString *)name
                              sourceId:(NSString *)sourceId
                              icon_url:(NSString *)icon_url
                                gender:(NSInteger)gender
                                   age:(NSInteger)age
                                custom:(NSString *)custom
                                 score:(CGFloat)score
                            levelTitle:(NSString *)levelTitle
                                 level:(NSInteger)level
                     contextDictionary:(NSDictionary *)context
                          userNameType:(UMComUserNameType)userNameType
                        userNameLength:(UMComUserNameLength)userNameLength
                            completion:(UMComRequestCompletion)completion;

/** 
 * 用户普通登录方式
 *
 * @param name 用户名 (必选， 但是只有第一次登录有效)
 * @param sourceType 平台类型（必选）
 * @param sourceId 平台用户ID（必选）
 * @param icon_url 用户头像地址(可选， 只有第一次登录有效)
 * @param gender 性别(可选， 只有第一次登录有效)
 * @param age 年龄(可选， 只有第一次登录有效)
 * @param custom 自定义字段(可选， 只有第一次登录有效)
 * @param score 积分(可选， 只有第一次登录有效)
 * @param levelTitle 等级title (可选， 只有第一次登录有效)
 * @param level 等级(可选， 只有第一次登录有效)
 * @param userNameType 用户名规则类型,参考枚举 'UMComUserNameType'
 * @param userNameLength 用户名长度规范，参考枚举 'UMComUserNameLength'
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)userLoginWithName:(NSString *)name
                   source:(UMComSnsType)sourceType
                 sourceId:(NSString *)sourceId
                 icon_url:(NSString *)icon_url
                   gender:(NSInteger)gender
                      age:(NSInteger)age
                   custom:(NSString *)custom
                    score:(CGFloat)score
               levelTitle:(NSString *)levelTitle
                    level:(NSInteger)level
        contextDictionary:(NSDictionary *)context
             userNameType:(UMComUserNameType)userNameType
           userNameLength:(UMComUserNameLength)userNameLength
               completion:(UMComRequestCompletion)completion;


/** 
 * 用户登录（使用友盟微社区用户系统）
 *
 * @param userAccount 用户邮箱账号（可用于找回密码）
 * @param password    用户密码
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)userLoginInUMCommunity:(NSString *)userAccount
                      password:(NSString *)password
                      response:(UMComRequestCompletion)completion;
/** 
 * 用户注册（使用友盟微社区用户系统）
 *
 * @param userAccount 用户邮箱账号
 * @param password    用户密码
 * @param name        用户昵称
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
*/
- (void)userSignUpUMCommunity:(NSString *)userAccount
                     password:(NSString *)password
                     nickName:(NSString *)name
                     response:(UMComRequestCompletion)completion;

/**
 * 找回密码（使用友盟微社区用户系统）
 *
 * @param userAccount 用户邮箱账号（可用于找回密码）
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)userPasswordForgetForUMCommunity:(NSString *)userAccount
                                response:(UMComRequestCompletion)completion;

/**
 * 更新登录用户数据
 *
 * @param name 用户名称
 * @param age 用户年龄
 * @param gender 用户性别
 * @param custom 用户自定义字段
 * @param userNameType 用户名规则类型,参考枚举 'UMComUserNameType'
 * @param userNameLength 用户名长度规范，参考枚举 'UMComUserNameLength'
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)updateProfileWithName:(NSString *)name
                          age:(NSNumber *)age
                       gender:(NSNumber *)gender
                       custom:(NSString *)custom
                 userNameType:(UMComUserNameType)userNameType
               userNameLength:(UMComUserNameLength)userNameLength
                   completion:(UMComRequestCompletion)completion;


/**
 * 更新用户头像 version 2.5
 *
 * @param image 可以是NSString（图片的url）类型,也可以是UIImage(直接传图片)
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)userUpdateAvatarWithImage:(id)image
                       completion:(UMComRequestCompletion)completion;

/** 
 * 更新用户地理位置信息
 *
 * @param location 位置
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)updateUserLocation:(CLLocation *)location
                completion:(UMComRequestCompletion)completion;


/** 
 * 举报用户
 *
 * @param uid 用户的id
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)userSpamWitUID:(NSString *)uid
            completion:(UMComRequestCompletion)completion;



/** 
 * 关注用户或者取消关注
 *
 * @param uid 用户的id
 * @param isFollow 关注用户或者取消关注
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)userFollowWithUserID:(NSString *)uid
                    isFollow:(BOOL)isFollow
                  completion:(UMComRequestCompletion)completion;

/**
 * 管理员对用户禁言
 *
 * @param uid 被禁言用户的id
 * @param topicIDs 禁言的话题的ID列表，即管理员可以根据自己的权限对某个用户在某个话题下禁言，全局管理员则具有任何话题下的禁言权限（必填）
 * @param ban   是否禁言，如果为YES表示禁言，如果为NO表示取消禁言(v2.3)
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)userBanWithUserId:(NSString *)userId
               inTopicIDs:(NSArray *)topicIDs
                      ban:(BOOL)ban
               completion:(UMComRequestCompletion)completion;


/**
 * 检查用户名合法接口
 *
 * @param name           用户名
 * @param userNameType   用户名规范, 参考枚举 'UMComUserNameType'
 * @param userNameLength 用户名长度规范，参考枚举 'UMComUserNameLength'
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)checkUserName:(NSString *)name
         userNameType:(UMComUserNameType)userNameType
       userNameLength:(UMComUserNameLength)userNameLength
           completion:(UMComRequestCompletion)completion;

/** 
 * 获取keywords相关的用户列表
 *
 * @param keywords 关键字
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchUsersFromSearchWithKeywords:(NSString *)keywords
                                   count:(NSInteger)count
                              completion:(UMComRequestCompletion)completion;

/**
 * 获取某个话题相关的活跃用户列表
 *
 * @param topicId 话题ID
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchUsersWithActiveTopicId:(NSString *)topicId
                              count:(NSInteger)count
                         completion:(UMComRequestCompletion)completion;

/**
 * 获取推荐的用户列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchUsersRecommentWithCount:(NSInteger)count
                          completion:(UMComRequestCompletion)completion;

/**
 * 获取某个用户的粉丝列表
 *
 * @param uid 用户ID
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchUserFansWithUid:(NSString *)uid
                       count:(NSInteger)count
                  completion:(UMComRequestCompletion)completion;

/**
 * 获取某个用户关注的人的列表
 *
 * @param uid 用户ID
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchUserFollowingsWithUid:(NSString *)uid
                             count:(NSInteger)count
                        completion:(UMComRequestCompletion)completion;

/**
 * 获取location（地理位置）附近的人列表
 *
 * @param location 地理位置
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchUserNearbyWithLocation:(CLLocation *)location
                              count:(NSInteger)count
                         completion:(UMComRequestCompletion)completion;


#pragma mark - Feed
/**
 * 获取实时热门Feed
 *
 * @param count   请求feed的数量
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchRealTimeHotFeedsWithCount:(NSInteger)count
                            completion:(UMComRequestCompletion)completion;

/**
 * 获取我关注的Feed列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsByFollowWithCount:(NSInteger)count
                         completion:(UMComRequestCompletion)completion;

/**
 * 获取推荐Feed列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsRecommentWithCount:(NSInteger)count
                          completion:(UMComRequestCompletion)completion;

/**
 * 获取最新的Feed列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsRealTimeWithCount:(NSInteger)count
                         completion:(UMComRequestCompletion)completion;

/**
 * 获取社区下的热门Feed列表
 *
 * @param days 热门天数
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsHotestWithDays:(NSInteger)days
                           count:(NSInteger)count
                      completion:(UMComRequestCompletion)completion;

/**
 * 获取好友的Feed列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsFriendsWithCount:(NSInteger)count
                        completion:(UMComRequestCompletion)completion;

/**
 * 获取keywords相关的Feed列表
 *
 * @param keywords 关键字
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsSearchWithKeywords:(NSString *)keywords
                               count:(NSInteger)count
                          completion:(UMComRequestCompletion)completion;

/**
 * 获取location（地理位置）附近的Feed列表
 *
 * @param location 地理位置
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsNearbyWithLocation:(CLLocation *)location
                               count:(NSInteger)count
                          completion:(UMComRequestCompletion)completion;

/**
 * 根据对应的feed的Id数组获取对应的Feed列表
 *
 * @param feedIds Feed的ID数组
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsWithFeedIds:(NSArray *)feedIds
                   completion:(UMComRequestCompletion)completion;


/**
 * 获取用户时间轴的Feed列表
 *
 * @param uid 用户ID
 * @param sortType 排序方式，参考枚举 'UMComTimeLineFeedListType'
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsTimelineWithUid:(NSString *)uid
                         sortType:(UMComTimeLineFeedListType)sortType
                            count:(NSInteger)count
                       completion:(UMComRequestCompletion)completion;

/**
 * 获取用户被@的Feed列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsUserBeAtWithCount:(NSInteger)count
                         completion:(UMComRequestCompletion)completion;

/**
 * 获取用户收藏的Feed列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsUserFavouriteWithCount:(NSInteger)count
                              completion:(UMComRequestCompletion)completion;


/**
 * 获取话题相关的Feed列表
 *
 * @param topicId 话题ID
 * @param sortType 排序方式，参考枚举 'UMComTopicFeedListSortType'
 * @param isReverse 与sortType字段配合使用，表示倒序还是正序（YES表示倒序，NO表示正序）
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsTopicRelatedWithTopicId:(NSString *)topicId
                                 sortType:(UMComTopicFeedListSortType)sortType
                                isReverse:(BOOL)isReverse
                                    count:(NSInteger)count
                               completion:(UMComRequestCompletion)completion;

/**
 * 获取话题下的热门Feed列表
 *
 * @param days 热门天数
 * @param topicId 话题ID
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsTopicHotWithDays:(NSInteger)days
                           topicId:(NSString *)topicId
                             count:(NSInteger)count
                        completion:(UMComRequestCompletion)completion;

/**
 * 获取该话题下推荐feed列表
 *
 * @param topicId 话题ID
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedsTopicRecommendWithTopicId:(NSString *)topicId
                                      count:(NSInteger)count
                                 completion:(UMComRequestCompletion)completion;


/**
 * 全局feed置顶接口
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchTopFeedWithCount:(NSInteger)count
               WithCompletion:(UMComRequestCompletion)completion;

/**
 * 话题feed置顶接口
 *
 * @param count      请求的count
 * @param topicID    对应话题id
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchTopTopicFeedWithCount:(NSInteger)count
                    topfeedTopicID:(NSString*)topicID
                    WithCompletion:(UMComRequestCompletion)completion;

/**
 * 获取单个
 *
 * @param feedId 关键字
 * @param commentId 评论ID（可选，当commentId有值时server端会将此条评论标记为已读）
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchFeedWithFeedId:(NSString *)feedId
                  commentId:(NSString *)commentId
                 completion:(UMComRequestCompletion)completion;


/**
 * 创建 feed（发消息）
 *
 * @param content Feed的内容
 * @param title 标题
 * @param location 位置
 * @param locationName 地理位置名称
 * @param related_uids @用户
 * @param topic_ids 话题ID数组
 * @param images 图片数组
 * @param type 类型（0表示普通，1表示公告，只有管理员才有权限发表公告）
 * @param custom 自定义字段
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
+ (void)feedCreateWithContent:(NSString *)content
                        title:(NSString *)title
                     location:(CLLocation *)location
                 locationName:(NSString *)locationName
                 related_uids:(NSArray<NSString *> *)related_uids
                    topic_ids:(NSArray<NSString *> *)topic_ids
                       images:(NSArray *)images
                         type:(NSNumber *)type
                       custom:(NSString *)custom
                   completion:(UMComRequestCompletion)completion;

/**
 * 点赞某个feed或取消
 *
 * @param feedId Feed的ID
 * @param isLike 点赞或者取消赞（YES表示点赞，NO表示取消点赞）
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)feedLikeWithFeedID:(NSString *)feedId
                    isLike:(BOOL)isLike
                completion:(UMComRequestCompletion)completion;


/**
 * 转发feed
 *
 * @param feedId 转发的feedid(必须发送)
 * @param content 转发的内容(可选发送)
 * @param topic_ids 转发带有的话题
 * @param uids 转发的相关用户ID
 * @param type feed类型（普通或则公告）
 * @param locationName 地理位置名称
 * @param location 地理位置
 * @param customContent 自定义内容
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)feedForwardWithFeedID:(NSString *)feedId
                      content:(NSString *)content
                    topic_ids:(NSArray *)topic_ids
                  relatedUids:(NSArray *)uids
                     feedType:(NSInteger)type
                 locationName:(NSString *)locationName
                     location:(CLLocation *)location
                       custom:(NSString *)customContent
                   completion:(UMComRequestCompletion)completion;


/**
 * 举报feed
 *
 * @param feedId Feed的ID
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)feedSpamWithFeedID:(NSString *)feedId
                completion:(UMComRequestCompletion)completion;

/**
 * 删除feed
 *
 * @param feedId Feed的ID
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)feedDeleteWithFeedID:(NSString *)feedId
                  completion:(UMComRequestCompletion)completion;


/**
 * 收藏某个feed操作/取消收藏某个feed操作
 *
 * @param feedId Feed的ID
 * @param isFavourite 收藏或取消收藏（YES表示收藏，NO表示取消收藏）
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)feedFavouriteWithFeedId:(NSString *)feedId
                    isFavourite:(BOOL)isFavourite
                    completionBlock:(UMComRequestCompletion)completion;

/**
 * 统计分享信息
 *
 * @param platform 分享的平台
 * @param feedId Feed的ID
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)feedShareToPlatform:(NSString *)platform
                     feedId:(NSString *)feedId
                 completion:(UMComRequestCompletion)completion;

/**
 * 获取未读feed消息数
 *
 * @param seq 我关注的Feed列表返回的第一条Feed的seq字段的值
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)feedUnreadCountWithSeq:(NSNumber *)seq completionBlock:(UMComRequestCompletion)completion;


#pragma mark - topic

/**
 * 获取所有的话题列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchTopicsAllWithCount:(NSInteger)count
                     completion:(UMComRequestCompletion)completion;

/**
 * 搜索keywords相关的话题列表
 *
 * @param keywords 关键字
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchTopicsSearchWithKeywords:(NSString *)keywords
                                count:(NSInteger)count
                           completion:(UMComRequestCompletion)completion;
/**
 * 获取某个用户关注的话题列表
 *
 * @param uid 用户ID
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchTopicsUserFocusWithUid:(NSString *)uid
                              count:(NSInteger)count
                         completion:(UMComRequestCompletion)completion;

/**
 * 获取推荐话题列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchTopicsRecommendWithCount:(NSInteger)count
                           completion:(UMComRequestCompletion)completion;

/**
 * 获取单个话题
 *
 * @param topicId 话题ID
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchTopicWithTopicId:(NSString *)topicId
                   completion:(UMComRequestCompletion)completion;

/**
 * 获取话题组列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchTopicGroupdsWithCount:(NSInteger)count
                        completion:(UMComRequestCompletion)completion;

/**
 * 获取组下的话题列表
 *
 * @param groupID 话题组ID
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchTopicsWithTopicGroupID:(NSString *)groupID
                              count:(NSInteger)count
                         completion:(UMComRequestCompletion)completion;

/**
 * 关注或取消关注某个话题
 *
 * @param topicId 话题ID
 * @param isFollow 关注或取消关注（YES表示关注， NO表示取消关注）
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)topicFollowerWithTopicID:(NSString *)topicId
                        isFollow:(BOOL)isFollow
                      completion:(UMComRequestCompletion)completion;



#pragma mark - comment

/**
 * 获取某个Feed的评论列表
 *
 * @param feedId Feed的ID
 * @param comment_uid 楼主的用户ID（可选）
 * @param sortType 排序方式，参考枚举 'UMComCommentListSortType'
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchCommentsWithFeedId:(NSString *)feedId
                  commentUserId:(NSString *)comment_uid
                       sortType:(UMComCommentListSortType)sortType
                          count:(NSInteger)count
                     completion:(UMComRequestCompletion)completion;


/**
 * 获取用户收到的评论列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchCommentsUserReceivedWithCount:(NSInteger)count
                                completion:(UMComRequestCompletion)completion;


/**
 * 获取用户写过的评论列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchCommentsUserSentWithCount:(NSInteger)count
                            completion:(UMComRequestCompletion)completion;

/**
 * 发送Feed带自定义字段的评论
 *
 * @param feedID   被评论的Feed的ID （必传）
 * @param commentContent 评论内容 （必传）
 * @param replyCommentID 回复的评论ID （可选，当回复某条评论时必传）
 * @param replyUserID 回复的用户ID （可选，当回复某个用户时必传）
 * @param commentCustomContent 评论自定义字段 （可选，用户根据自己业务需要添加的扩展字段）
 * @param images 评论附带图片（images中的对象可以是UIIamge类对象，也可以直接是图片的urlString）,图片限制3张（可选）
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)commentFeedWithFeedID:(NSString *)feedID
               commentContent:(NSString *)commentContent
               replyCommentID:(NSString *)replyCommentID
                  replyUserID:(NSString *)replyUserID
         commentCustomContent:(NSString *)commentCustomContent
                       images:(NSArray *)images
                   completion:(UMComRequestCompletion)completion;

/**
 * 举报feed的评论
 *
 * @param commentID 评论的ID
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)commentSpamWithCommentID:(NSString *)commentID
                      completion:(UMComRequestCompletion)completion;


/**
 * 删除feed的评论
 *
 * @param commentID 删除的评论
 * @param feedID 评论的Feed的ID
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)commentDeleteWithCommentID:(NSString *)commentID
                            feedID:(NSString *)feedID
                        completion:(UMComRequestCompletion)completion;

/**
 * 评论点赞或取消点赞
 *
 * @param commentID   评论的ID
 * @param isLike      是否点赞，如果点赞则为YES,取消点赞则为NO
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)commentLikeWithCommentID:(NSString *)commentID
                          isLike:(BOOL)isLike
                      completion:(UMComRequestCompletion)completion;

#pragma mark - like
/**
 * 获取某个Feed的点赞列表
 *
 * @param feedId Feed的ID
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchLikesFeedWithFeedId:(NSString *)feedId
                           count:(NSInteger)count
                      completion:(UMComRequestCompletion)completion;

/**
 * 获取用户点赞列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchLikesUserReceivedWithCount:(NSInteger)count
                             completion:(UMComRequestCompletion)completion;

/**
 * 获取用户点赞记录
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchLikesUserSendsWithCount:(NSInteger)count
                          completion:(UMComRequestCompletion)completion;

#pragma mark - notification

/**
 * 获取用户通知列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchMyNotificationWithCount:(NSInteger)count
                          completion:(UMComRequestCompletion)completion;


#pragma mark - album

/**
 * 获取用户相册列表
 *
 * @param uid 用户ID
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchAlbumWithUid:(NSString *)uid
                    count:(NSInteger)count
               completion:(UMComRequestCompletion)completion;

#pragma mark - Private Letter
/**
 * 获取私信列表
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchPrivateLetterWithCount:(NSInteger)count
                         completion:(UMComRequestCompletion)completion;

/**
 * 获取私信聊天记录
 *
 * @param toUid 私信聊天对象ID
 * @param private_letter_id 私信窗口ID
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchPrivateChartRecordWithUid:(NSString *)toUid
                     private_letter_id:(NSString *)private_letter_id
                                 count:(NSInteger)count
                            completion:(UMComRequestCompletion)completion;

/**
 * 初始化私信窗口
 *
 * @param toUId 私信聊天对象ID
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)getChartBoxWithUid:(NSString *)toUId
                 completion:(UMComRequestCompletion)completion;
/**
 * 发送私信
 *
 * @param content 私信内容
 * @param toUid 接收私信的用户ID
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)privateMessageSendWithContent:(NSString *)content
                                toUid:(NSString *)toUid
                           completion:(UMComRequestCompletion)completion;


#pragma mark - location
/**
 * 获取附近地理位置列表
 *
 * @param location 当前位置
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchLocationNamesWithLocation:(CLLocation *)location
                            completion:(UMComRequestCompletion)completion;


#pragma mark - 社区级别

/**
 * 获取初始化数据和更新未读消息数
 *
 * @param completion 初始化数据结果，`responseObject`的key`config.feed_length`为设置最大feed文字内容 `responseObject`的key`msg_box`是各个未读消息数，`msg_box`下面的`total`为所有未读通知数，key为`notice`为管理员未读通知数，`comment`为被评论未读通知数，`at`为被@未读通知数，`like`为被点赞未读通知数
 * @warning 这些数据都会保存在UMComSession单利里面 `config.feed_lenght`对应的UMComSession的maxFeedLength属性，`message_box`保存在UMComSession的unReadNoticeModel属性里面，unReadNoticeModel是`UMComUnReadNoticeModel`类的对象，
 
 
 */
- (void)fetchConfigDataWithCompletion:(UMComRequestCompletion)completion;

/**
 * 统计UI模板使用量
 *
 * @param choice 使用的UI模板，0表示微博版， 1表示论坛版，2表示精简版
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)updateTemplateChoice:(NSUInteger)choice
                    completion:(UMComRequestCompletion)completion;

/**
 * 获取社区统计字段
 *
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
- (void)fetchCommunityStatisticsDataWithCompletion:(UMComRequestCompletion)completion;

/**
 * 获取社区访客模式信息
 *
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
-(void)fetchCommunityGuestWithCompletion:(UMComRequestCompletion)completion;

/**
 * 获取token
 *
 * @param appKey
 * @param appSecret
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
-(void)fetchCommunityTokenWithAppkey:(NSString *)appKey
                           appSecret:(NSString *)appSecret
                          completion:(UMComRequestCompletion)completion;


#pragma mark -积分相关函数

/**
 * 获得当前登录用户的积分明细
 *
 * @param count    请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
+(void) getCommunityPointDetailWithCount:(NSInteger)count
                                response:(UMComRequestCompletion)completion;


/**
 * 积分的增减接口
 *
 * @param point    增加或者减少的积分数 正数代表加积分，负数代表减积分(必传参数，必须传入有效值)
 * @param desc     当前操作积分的描述(必传参数,必须传入有效值)
 * @param use_unit 是否使用unit(0/1,默认为0)(此参数为0或者1) 1代表用protal后台的积分基数 0 代表不用(可选参数)
 * @param identity 自定义业务ID，长度在128一下
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
+(void) postCommunityPointOperationWithPoint:(NSInteger)point
                                        desc:(NSString*)desc
                                    use_unit:(NSInteger)use_unit
                                    identity:(NSString*)identity
                                    response:(UMComRequestCompletion)completion;


#pragma mark - 获得货币明细
/**
 * 获得货币明细
 *
 * @param count 请求个数
 * @param completion 请求回调block，参考 'UMComRequestCompletion'
 * @return 返回空指针
 */
+(void) getCommunityCurrencyDetailWithCount:(NSInteger)count
                                   response:(UMComRequestCompletion)completion;


@end

