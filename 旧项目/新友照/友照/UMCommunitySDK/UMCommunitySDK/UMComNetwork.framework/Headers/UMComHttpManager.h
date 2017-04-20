//
//  UMComHttpManager.h
//  UMCommunity
//
//  Created by luyiyuan on 14/8/27.
//  Copyright (c) 2014年 luyiyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import "UMComNetworkConstant.h"

/*
 #import <UMComNetwork/UMComNetworkConfig.h>

 
 */
@interface UMComHttpManager : NSObject

+ (UMComHttpManager *)shareInstance;

/******************Page request method List start*********************************/

/**
 * 获取下一页请求
 *
 * @param urlString 下一页请求的url
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getRequestNextPageWithNextPageUrl:(NSString *)urlString
                                 response:(UMComHttpRequestCompletion)response;


#pragma mark - user

/**
 * 获取某个用户的详细信息
 *
 * @param uid 用户的ID
 * @param source 平台名称
 * @param source_uid 所在平台用户ID
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserProfileWithFuid:(NSString *)uid
                        source:(NSString *)source
                    source_uid:(NSString *)source_uid
                      response:(UMComHttpRequestCompletion)response;
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
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)userLoginWithName:(NSString *)name
                   source:(UMComSnsType)source
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
                 response:(UMComHttpRequestCompletion)response;

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
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)userLoginInCustomAccountWithName:(NSString *)name
                                sourceId:(NSString *)sourceId
                                icon_url:(NSString *)icon_url
                                  gender:(NSInteger)gender
                                     age:(NSInteger)age
                                  custom:(NSString *)custom
                                   score:(CGFloat)score
                              levelTitle:(NSString *)levelTitle
                                   level:(NSInteger)level
                            userNameType:(UMComUserNameType)userNameType
                          userNameLength:(UMComUserNameLength)userNameLength
                                response:(UMComHttpRequestCompletion)response;

/**
 * 用户登录（使用友盟微社区用户系统）
 *
 * @param userAccount 用户邮箱账号（可用于找回密码）
 * @param password    用户密码
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)userLoginInUMCommunity:(NSString *)userAccount
                      password:(NSString *)password
                      response:(UMComHttpRequestCompletion)response;

/**
 * 用户注册（使用友盟微社区用户系统）
 *
 * @param userAccount 用户邮箱账号
 * @param password    用户密码
 * @param name        用户昵称
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)userSignUpUMCommunity:(NSString *)userAccount
                     password:(NSString *)password
                     nickName:(NSString *)name
                     response:(UMComHttpRequestCompletion)response;

/**
 * 找回密码（使用友盟微社区用户系统）
 *
 * @param userAccount 用户邮箱账号（可用于找回密码）
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)userPasswordForgetForUMCommunity:(NSString *)userAccount
                                response:(UMComHttpRequestCompletion)response;

/**
 * 更新登录用户数据
 *
 * @param name 用户名称
 * @param age 用户年龄
 * @param gender 用户性别
 * @param custom 用户自定义字段
 * @param userNameType 用户名规则类型,参考枚举 'UMComUserNameType'
 * @param userNameLength 用户名长度规范，参考枚举 'UMComUserNameLength'
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)updateProfileWithName:(NSString *)name
                          age:(NSNumber *)age
                       gender:(NSNumber *)gender
                       custom:(NSString *)custom
                 userNameType:(UMComUserNameType)userNameType
               userNameLength:(UMComUserNameLength)userNameLength
                     response:(UMComHttpRequestCompletion)response;

/**
 * 更新用户头像 version 2.5
 *
 * @param image 可以是NSString（图片的url）类型,也可以是UIImage(直接传图片)
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)updateUserIcon:(id)icon
              response:(UMComHttpRequestCompletion)response;

/**
 * 更新用户地理位置信息
 *
 * @param location 位置
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)updateUserLocation:(CLLocation *)location
                  response:(UMComHttpRequestCompletion)response;

/**
 * 关注用户或者取消关注
 *
 * @param uid 用户的id
 * @param isFollow 关注用户或者取消关注
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)followWithUserID:(NSString *)uid
                isFollow:(BOOL)isFollow
                response:(UMComHttpRequestCompletion)response;

/**
 * 举报用户
 *
 * @param uid 用户的id
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)spamUser:(NSString *)uid
        response:(UMComHttpRequestCompletion)response;

/**
 * 管理员对用户禁言
 *
 * @param uid 被禁言用户的id
 * @param topicIDs 禁言的话题的ID列表，即管理员可以根据自己的权限对某个用户在某个话题下禁言，全局管理员则具有任何话题下的禁言权限（必填）
 * @param ban   是否禁言，如果为YES表示禁言，如果为NO表示取消禁言(v2.3)
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)banUserWithUserId:(NSString *)uid
               inTopicIDs:(NSArray *)topicIDs
                      ban:(BOOL)ban
               completion:(UMComHttpRequestCompletion)result;
/**
 * 检查用户名合法接口
 *
 * @param name           用户名
 * @param userNameType   用户名规范, 参考枚举 'UMComUserNameType'
 * @param userNameLength 用户名长度规范，参考枚举 'UMComUserNameLength'
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)checkUserName:(NSString *)name
         userNameType:(UMComUserNameType)userNameType
       userNameLength:(UMComUserNameLength)userNameLength
          resultBlock:(UMComHttpRequestCompletion)response;

/**
 * 获取keywords相关的用户列表
 *
 * @param keywords 关键字
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getSearchUsersWithCount:(NSInteger)count
                       keywords:(NSString *)keywords
                       response:(UMComHttpRequestCompletion)response;

/* 获取某个话题相关的活跃用户列表
*
* @param topicId 话题ID
* @param count 请求个数
* @param response 请求回调block，参考 'UMComHttpRequestCompletion'
* @return 返回空指针
*/
+ (void)getTopicActiveUsersWithCount:(NSInteger)count
                             topicId:(NSString *)topicId
                            response:(UMComHttpRequestCompletion)response;

/**
 * 获取推荐的用户列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getRecommentUsersWithCount:(NSInteger)count
                          response:(UMComHttpRequestCompletion)response;

/**
 * 获取某个用户的粉丝列表
 *
 * @param uid 用户ID
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserFansWithCount:(NSInteger)count
                        fuid:(NSString *)uid
                    response:(UMComHttpRequestCompletion)response;

/**
 * 获取某个用户关注的人的列表
 *
 * @param uid 用户ID
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserFollowingsWithCount:(NSInteger)count
                              fuid:(NSString *)uid
                          response:(UMComHttpRequestCompletion)response;

/**
* 获取location（地理位置）附近的人列表
*
* @param location 地理位置
* @param count 请求个数
* @param response 请求回调block，参考 'UMComHttpRequestCompletion'
* @return 返回空指针
*/
+ (void)getUserNearbyWithCount:(NSInteger)count
                      location:(CLLocation *)location
                      response:(UMComHttpRequestCompletion)response;





#pragma mark - Feed

/**
 * 获取实时热门Feed
 *
 * @param count   请求feed的数量
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getRealTimeHotFeedsWithCount:(NSInteger)count
                            response:(UMComHttpRequestCompletion)response;


/**
 * 获取最新的Feed列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getRealTimeFeedsWithCount:(NSInteger)count
                         response:(UMComHttpRequestCompletion)response;

/**
 * 全局feed置顶接口
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getTopFeedsWithTopFeedCount:(NSInteger)topFeedCount
                           response:(UMComHttpRequestCompletion)response;

/**
 * 话题feed置顶接口
 *
 * @param count      请求的count
 * @param topicID    对应话题id
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getFeedsTopicTopWithTopicID:(NSString *)topicID
                              count:(NSInteger)count
                           response:(UMComHttpRequestCompletion)response;

/**
 * 获取我关注的Feed列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserFocusFeedsWithCount:(NSInteger)count
                          response:(UMComHttpRequestCompletion)response;
/**
 * 获取社区下的热门Feed列表
 *
 * @param days 热门天数
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getHotFeedsWithCount:(NSInteger)count
                  withinDays:(NSInteger)days
                    response:(UMComHttpRequestCompletion)response;

/**
 * 获取推荐Feed列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getRecommendFeedsWithCount:(NSInteger)count
                          response:(UMComHttpRequestCompletion)response;

/**
 * 获取好友的Feed列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getFriendFeedsWithCount:(NSInteger)count
                       response:(UMComHttpRequestCompletion)response;

/**
 * 获取keywords相关的Feed列表
 *
 * @param keywords 关键字
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getSearchFeedsWithCount:(NSInteger)count
                       keywords:(NSString *)keywords
                       response:(UMComHttpRequestCompletion)response;

/**
 * 获取location（地理位置）附近的Feed列表
 *
 * @param location 地理位置
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getNearbyFeedsWithCount:(NSInteger)count
                       location:(CLLocation *)location
                       response:(UMComHttpRequestCompletion)response;

/**
 * 根据对应的feed的Id数组获取对应的Feed列表
 *
 * @param feedIds Feed的ID数组
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getFeedsWithFeedIds:(NSArray *)feedIds
                   response:(UMComHttpRequestCompletion)response;

/**
 * 获取单个
 *
 * @param feedId 关键字
 * @param commentId 评论ID（可选，当commentId有值时server端会将此条评论标记为已读）
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getOneFeedWithFeedId:(NSString *)feedId
                   commentId:(NSString *)commentId
                    response:(UMComHttpRequestCompletion)response;

/**
 * 获取用户时间轴的Feed列表
 *
 * @param uid 用户ID
 * @param sortType 排序方式，参考枚举 'UMComTimeLineFeedListType'
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserTimelineWithCount:(NSInteger)count
                            fuid:(NSString *)uid
                        sortType:(UMComTimeLineFeedListType)sortType
                        response:(UMComHttpRequestCompletion)response;

/**
 * 获取用户被@的Feed列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserBeAtFeedWithCount:(NSInteger)count
                        response:(UMComHttpRequestCompletion)response;

/**
 * 获取用户收藏的Feed列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserFavouriteFeedsWithCount:(NSInteger)count
                              response:(UMComHttpRequestCompletion)response;

/**
 * 获取话题相关的Feed列表
 *
 * @param topicId 话题ID
 * @param sortType 排序方式，参考枚举 'UMComTopicFeedListSortType'
 * @param isReverse 与sortType字段配合使用，表示倒序还是正序（YES表示倒序，NO表示正序）
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getTopicRelatedFeedsWithCount:(NSInteger)count
                              topicId:(NSString *)topicId
                             sortType:(UMComTopicFeedListSortType)sortType
                            isReverse:(BOOL)isReverse
                             response:(UMComHttpRequestCompletion)response;

/**
 * 获取话题下的热门Feed列表
 *
 * @param days 热门天数
 * @param topicId 话题ID
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getTopicHotFeedsWithCount:(NSInteger)count
                       withinDays:(NSInteger)days
                          topicId:(NSString *)topicId
                         response:(UMComHttpRequestCompletion)response;

/**
 * 获取该话题下推荐feed列表
 *
 * @param topicId 话题ID
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getTopicRecommendFeedsWithCount:(NSInteger)count
                                topicId:(NSString *)topicId
                               response:(UMComHttpRequestCompletion)response;

/**
 * 获取未读feed消息数
 *
 * @param seq 我关注的Feed列表返回的第一条Feed的seq字段的值
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)unreadFeedCountWithSeq:(NSNumber *)seq resultBlock:(UMComHttpRequestCompletion)response;


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
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)createFeedWithContent:(NSString *)content
                        title:(NSString *)title
                     location:(CLLocation *)location
                 locationName:(NSString *)locationName
                 related_uids:(NSArray<NSString *> *)related_uids
                    topic_ids:(NSArray<NSString *> *)topic_ids
                       images:(NSArray *)images
                         type:(NSNumber *)type
                       custom:(NSString *)custom
                     response:(UMComHttpRequestCompletion)response;

/**
 * 点赞某个feed或取消
 *
 * @param feedId Feed的ID
 * @param isLike 点赞或者取消赞（YES表示点赞，NO表示取消点赞）
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)likeFeed:(NSString *)feedId
          isLike:(BOOL)isLike
        response:(UMComHttpRequestCompletion)response;

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
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)feedForwardWithFeedID:(NSString *)feedId
                      content:(NSString *)content
                    topic_ids:(NSArray *)topic_ids
                  relatedUids:(NSArray *)uids
                     feedType:(NSNumber *)type
                 locationName:(NSString *)locationName
                     location:(CLLocation *)location
                       custom:(NSString *)customContent
                     response:(UMComHttpRequestCompletion)response;


/**
 * 举报feed
 *
 * @param feedId Feed的ID
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)spamFeed:(NSString *)feedId
        response:(UMComHttpRequestCompletion)response;

/**
 * 删除feed
 *
 * @param feedId Feed的ID
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)deleteFeed:(NSString *)feedId
          response:(UMComHttpRequestCompletion)response;


/**
 * 收藏某个feed操作/取消收藏某个feed操作
 *
 * @param feedId Feed的ID
 * @param isFavourite 收藏或取消收藏（YES表示收藏，NO表示取消收藏）
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)favouriteFeedWithFeedId:(NSString *)feedId
                    isFavourite:(BOOL)isFavourite
                    resultBlock:(UMComHttpRequestCompletion)response;

/**
 * 统计分享信息
 *
 * @param platform 分享的平台
 * @param feedId Feed的ID
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)feedShareToPlatform:(NSString *)platform
                     feedId:(NSString *)feedId
                   response:(UMComHttpRequestCompletion)response;



#pragma mark - topic

/**
 * 获取所有的话题列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getAllTopicsWithCount:(NSInteger)count
                     response:(UMComHttpRequestCompletion)response;

/**
 * 搜索keywords相关的话题列表
 *
 * @param keywords 关键字
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getSearchTopicsWithCount:(NSInteger)count
                        keywords:(NSString *)keywords
                        response:(UMComHttpRequestCompletion)response;

/**
 * 获取某个用户关注的话题列表
 *
 * @param uid 用户ID
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserFocusTopicsWithCount:(NSInteger)count
                               fuid:(NSString *)uid
                           response:(UMComHttpRequestCompletion)response;

/**
 * 获取推荐话题列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getRecommendTopicsWithCount:(NSInteger)count
                           response:(UMComHttpRequestCompletion)response;

/**
 * 获取单个话题
 *
 * @param topicId 话题ID
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getOneTopicWithTopicId:(NSString *)topicId
                      response:(UMComHttpRequestCompletion)response;

/**
 * 获取话题组列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getTopicGroupsWithCount:(NSInteger)count
                       response:(UMComHttpRequestCompletion)response;

/**
 * 获取组下的话题列表
 *
 * @param groupID 话题组ID
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getTopicsWithTopicGroupID:(NSString *)groupID
                            count:(NSInteger)count
                         response:(UMComHttpRequestCompletion)response;

/**
 * 关注或取消关注某个话题
 *
 * @param topicId 话题ID
 * @param isFollow 关注或取消关注（YES表示关注， NO表示取消关注）
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)topicFollowerWithTopicID:(NSString *)topicId
                        isFollow:(BOOL)isFollow
                        response:(UMComHttpRequestCompletion)response;

#pragma mark - like

/**
 * 获取某个Feed的点赞列表
 *
 * @param feedId Feed的ID
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getFeedLikesWithCount:(NSInteger)count
                       feedId:(NSString *)feedId
                     response:(UMComHttpRequestCompletion)response;

/**
 * 获取用户点赞列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserLikesReceivedWithCount:(NSInteger)count
                             response:(UMComHttpRequestCompletion)response;

/**
 * 获取用户点赞记录
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserLikesSendsWithCount:(NSInteger)count
                          response:(UMComHttpRequestCompletion)response;

#pragma mark - comment

/**
 * 获取某个Feed的评论列表
 *
 * @param feedId Feed的ID
 * @param comment_uid 楼主的用户ID（可选）
 * @param sortType 排序方式，参考枚举 'UMComCommentListSortType'
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getFeedCommentsWithCount:(NSInteger)count
                          feedId:(NSString *)feedId
                   commentUserId:(NSString *)comment_uid
                        sortType:(UMComCommentListSortType)sortType
                        response:(UMComHttpRequestCompletion)response;

/**
 * 获取用户收到的评论列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserCommentsReceivedWithCount:(NSInteger)count
                                response:(UMComHttpRequestCompletion)response;

/**
 * 获取用户写过的评论列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserCommentsSentWithCount:(NSInteger)count
                            response:(UMComHttpRequestCompletion)response;

/**
 * 发送Feed带自定义字段的评论
 *
 * @param feedID   被评论的Feed的ID （必传）
 * @param commentContent 评论内容 （必传）
 * @param replyCommentID 回复的评论ID （可选，当回复某条评论时必传）
 * @param replyUid 回复的用户ID （可选，当回复某个用户时必传）
 * @param commentCustomContent 评论自定义字段 （可选，用户根据自己业务需要添加的扩展字段）
 * @param images 评论附带图片（images中的对象可以是UIIamge类对象，也可以直接是图片的urlString）,图片限制3张（可选）
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)commentFeedWithfeedID:(NSString *)feedID
                      content:(NSString *)content
                     replyUid:(NSString *)replyUid
               replyCommentID:(NSString *)replyCommentID
                commentCustom:(NSString *)commentCustom
                       images:(NSArray *)images
                     response:(UMComHttpRequestCompletion)response;

/**
 * 举报feed的评论
 *
 * @param commentId 评论的ID
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)spamComment:(NSString *)commentId
           response:(UMComHttpRequestCompletion)response;

/**
 * 删除feed的评论
 *
 * @param commentId 删除的评论
 * @param feedId 评论的Feed的ID
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)deleteComment:(NSString *)commentId
               feedId:(NSString *)feedId
             response:(UMComHttpRequestCompletion)response;

/**
 * 评论点赞或取消点赞
 *
 * @param commentId   评论的ID
 * @param isLike      是否点赞，如果点赞则为YES,取消点赞则为NO
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)likeComment:(NSString *)commentId
             isLike:(BOOL)isLike
           response:(UMComHttpRequestCompletion)response;


#pragma mark - notification

/**
 * 获取用户通知列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserNotificationWithCount:(NSInteger)count
                            response:(UMComHttpRequestCompletion)response;


#pragma mark - album
/**
 * 获取用户相册列表
 *
 * @param uid 用户ID
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getUserAlbumWithCount:(NSInteger)count
                         fuid:(NSString *)uid
                     response:(UMComHttpRequestCompletion)response;

#pragma mark - Private Letter 

/**
 * 获取私信列表
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getPrivateLetterWithCount:(NSInteger)count
                         response:(UMComHttpRequestCompletion)response;

/**
 * 获取私信聊天记录
 *
 * @param toUid 私信聊天对象ID
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getPrivateChartRecordWithCount:(NSInteger)count
                                 toUid:(NSString *)toUid
                              response:(UMComHttpRequestCompletion)response;

/**
 * 初始化私信窗口
 *
 * @param toUId 私信聊天对象ID
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)initChartBoxWithToUid:(NSString *)toUId
                    responese:(UMComHttpRequestCompletion)response;

/**
 * 发送私信
 *
 * @param content 私信内容
 * @param toUid 接收私信的用户ID
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)sendPrivateMessageWithContent:(NSString *)content
                                toUid:(NSString *)toUid
                            responese:(UMComHttpRequestCompletion)response;

/******************Page request method List end*********************************/


#pragma mark - other

/**
 * 获取附近地理位置列表
 *
 * @param location 当前位置
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getLocationNamesWithLocation:(CLLocationCoordinate2D)coordinate
                            response:(UMComHttpRequestCompletion)response;

/**
 * 获取初始化数据和更新未读消息数
 *
 * @param completion 初始化数据结果，`responseObject`的key`config.feed_length`为设置最大feed文字内容 `responseObject`的key`msg_box`是各个未读消息数，`msg_box`下面的`total`为所有未读通知数，key为`notice`为管理员未读通知数，`comment`为被评论未读通知数，`at`为被@未读通知数，`like`为被点赞未读通知数
 
 */
+ (void)getConfigDataWithResponse:(UMComHttpRequestCompletion)response;

/**
 * 统计UI模板使用量
 *
 * @param choice 使用的UI模板，0表示微博版， 1表示论坛版，2表示精简版
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)updateTemplateChoice:(NSUInteger)choice
                    response:(UMComHttpRequestCompletion)response;



#pragma mark - 统计

/**
 * 获取社区统计字段
 *
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+ (void)getCommunityStatisticsDataWithResponese:(UMComHttpRequestCompletion)response;

#pragma mark  获得访客模式
/**
 * 获取社区访客模式信息
 *
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+(void)getCommunityGuestWithResponse:(UMComHttpRequestCompletion)response;

/**
 * 获取token
 *
 * @param appKey
 * @param appSecret
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+(void)getCommunityTokenWithAppkey:(NSString *)appKey
                         appSecret:(NSString *)appSecret
                          response:(UMComHttpRequestCompletion)response;


#pragma mark - 获得积分明细

/**
 * 获得当前登录用户的积分明细
 *
 * @param count    请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+(void) getCommunityPointDetailWithCount:(NSInteger)count
                                response:(UMComHttpRequestCompletion)response;

#pragma mark - 积分的增减操作
/**
 * 积分的增减接口
 *
 * @param point    增加或者减少的积分数 正数代表加积分，负数代表减积分(必传参数，必须传入有效值)
 * @param desc     当前操作积分的描述(必传参数,必须传入有效值)
 * @param use_unit 是否使用unit(0/1,默认为0)(此参数为0或者1) 1代表用protal后台的积分基数 0 代表不用(可选参数)
 * @param identity 自定义业务ID，长度在128一下
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+(void) postCommunityPointOperationWithPoint:(NSInteger)point
                                        desc:(NSString*)desc
                                    use_unit:(NSInteger)use_unit
                                    identity:(NSString*)identity
                                    response:(UMComHttpRequestCompletion)response;

#pragma mark - 获得货币明细
/**
 * 获得货币明细
 *
 * @param count 请求个数
 * @param response 请求回调block，参考 'UMComHttpRequestCompletion'
 * @return 返回空指针
 */
+(void) getCommunityCurrencyDetailWithCount:(NSInteger)count
                                   response:(UMComHttpRequestCompletion)response;

@end
