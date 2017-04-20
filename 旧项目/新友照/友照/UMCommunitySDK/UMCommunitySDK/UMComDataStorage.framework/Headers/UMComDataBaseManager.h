//
//  UMComDataBaseManager.h
//  UMCommunity
//
//  Created by 张军华 on 16/5/16.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComRelatedIDTableType.h"

@class UMComModelObject,UMComFeed, UMComUser,UMComTopic,UMComMedal,UMComImageUrl,UMComTopicType,UMComComment,UMComAlbum,UMComLike,UMComNotification,UMComPrivateMessage,UMComPrivateLetter;

@interface UMComDataBaseManager : NSObject


+(instancetype)shareManager;

#pragma mark -reset数据库

-(void) resetDataBase;

#pragma mark - 单独储存对象
/**
 *  存储一组继承UMComModelObject
 *
 *  @param umComModelObjects 包含继承UMComModelObject的数组
 *  @discuss 只是存储一组继承UMComModelObject的对象
 */
-(void)saveUMComModelObjects:(NSArray*)umComModelObjects;

-(void)saveUMComFeed:(UMComFeed*)feed;
-(void)saveUMComUser:(UMComUser*)user;
-(void)saveUMComTopic:(UMComTopic*)topic;
-(void)saveUMComTopicType:(UMComTopicType*)topicType;
-(void)saveUMComMedal:(UMComMedal*)medal;
-(void)saveUMComImageUrl:(UMComImageUrl*)imageUrl;
-(void)saveUMComComment:(UMComComment*)comment;
-(void)saveUMComAlbum:(UMComAlbum*)album;
-(void)saveUMComLike:(UMComLike*)like;
-(void)saveUMComNotification:(UMComNotification*)notification;
-(void)saveUMComPrivateMessage:(UMComPrivateMessage*)privateMessage;
-(void)saveUMComPrivateLetter:(UMComPrivateLetter*)privateLetter;

#pragma mark - 储存对象和对象关联的relation表
/**
 *  存储相关的feed array 和对应feedID的relation表
 *
 *  @param type  @see UMComRelatedIDTableType
 *  @param feeds feed对象 @see UMComFeed
 */
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type withFeeds:(NSArray*)feeds;

/**
 *  存储相关的user array 和对应uid的relation表
 *
 *  @param type  @see UMComRelatedIDTableType
 *  @param feeds feed对象 @see UMComUser
 */
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type withUsers:(NSArray*)users;

/**
 *  存储相关的topic array和对应topicID的relation表
 *
 *  @param type  topic相关的类型
 *  @param users topic对象 @see UMComTopic
 */
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type withTopics:(NSArray*)topics;

/**
 *  存储相关的UMComTopicType array和对应UMComTopicType的ID的relation表
 *
 *  @param type      topic相关的类型
 *  @param topicType UMComTopicType对象 @see UMComTopicType
 */
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type withTopicTypes:(NSArray*)topicTypes;

/**
 *  存储相关的UMComTopicType array和对应UMComTopicType的ID的relation表
 *
 *  @param type      topic相关的类型
 *  @param topicType UMComComment对象 @see UMComTopicType
 */
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type  withComments:(NSArray*)comments;


/**
 *  存储相关的UMComAlbum array和对应UMComAlbum的ID的relation表
 *
 *  @param type      topic相关的类型
 *  @param albums    UMComAlbum数组 @see UMComAlbum
 */
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type withAlbums:(NSArray*)albums;

/**
 *  存储相关的UMComLike array和对应UMComLike的ID的relation表
 *
 *  @param type      topic相关的类型
 *  @param topicType UMComLike对象 @see UMComLike
 */
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type  withLikes:(NSArray*)likes;

/**
 *  存储相关的UMComNotification array和对应UMComNotification的ID的relation表
 *
 *  @param type      topic相关的类型
 *  @param topicType UMComNotification对象 @see UMComNotification
 */
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type withNotifications:(NSArray*)notifications;

/**
 *  存储相关id的type的ID(比如：推荐界面)
 *
 *  @param type   @see UMComRelatedIDTableType
 *  @param values 对应的唯一id的数据
 */
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type withValues:(NSArray*)values;


#pragma mark - fetch对象通过对象关联的relation表
/**
 *  获取关联type的数据库的feed数据
 *
 *  @param type @see UMComRelatedIDTableType
 *
 *  @return 返回包含UMComFeed的数组
 */
-(id)fetchSyncUMComFeedWithType:(UMComRelatedIDTableType)type;
-(void)fetchASyncUMComFeedWithType:(UMComRelatedIDTableType)type withCompleteBlock:(void(^)(id,NSError*))completeBlock;


/**
 *  获得关联type的数据的user的数据
 *
 *  @param type @see UMComRelatedIDTableType
 *
 *  @return 返回包含UMComUser的数组
 */
-(id)fetchSyncUMComUserWithType:(UMComRelatedIDTableType)type;
-(void)fetchASyncUMComUserWithType:(UMComRelatedIDTableType)type withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  获得关联type的数据的topic的数据
 *
 *  @param type @see UMComRelatedIDTableType
 *
 *  @return 返回包含UMComTopic的数组
 */
-(id)fetchSyncUMComTopicWithType:(UMComRelatedIDTableType)type;
-(void)fetchASyncUMComTopicWithType:(UMComRelatedIDTableType)type withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  获得关联type的数据的topicType的数据
 *
 *  @param type @see UMComRelatedIDTableType
 *
 *  @return 返回包含UMComTopicType的数组
 */
-(id)fetchSyncUMComTopicTypeWithType:(UMComRelatedIDTableType)type;
-(void)fetchASyncUMComTopicTypeWithType:(UMComRelatedIDTableType)type withCompleteBlock:(void(^)(id,NSError*))completeBlock;


/**
 *  获得关联type的数据的type类型的UMComComment流
 *
 *  @param type          @see UMComRelatedIDTableType
 *  @param completeBlock 回调函数
 */
-(id)fetchSyncUMComCommentWithType:(UMComRelatedIDTableType)type;
-(void)fetchASyncUMComCommentWithType:(UMComRelatedIDTableType)type withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  查找属于type类型的UMComAlbum流
 *
 *  @param type @see UMComRelatedIDTableType
 *
 *  @return 返回一个包含字典的数组
 */
-(id)fetchSyncUMComAlbumWithType:(UMComRelatedIDTableType)type;
-(void)fetchASyncUMComAlbumWithType:(UMComRelatedIDTableType)type withCompleteBlock:(void(^)(id,NSError*))completeBlock;


/**
 *  查找属于type类型的UMComLike流
 *
 *  @param type @see UMComRelatedIDTableType
 *  @param completeBlock 回调函数
 *
 *  @return 返回一个包含字典的数组
 */
-(id)fetchSyncUMComLikeWithType:(UMComRelatedIDTableType)type;
-(void)fetchASyncUMComLikeWithType:(UMComRelatedIDTableType)type withCompleteBlock:(void(^)(id,NSError*))completeBlock;


/**
 *  查找属于type类型的UMComNotification流
 *
 *  @param type @see UMComRelatedIDTableType
 *  @param completeBlock 回调函数
 *
 *  @return 返回一个包含字典的数组
 */
-(id)fetchSyncUMComNotificationWithType:(UMComRelatedIDTableType)type;
-(void)fetchASyncUMComNotificationWithType:(UMComRelatedIDTableType)type withCompleteBlock:(void(^)(id,NSError*))completeBlock;
#pragma mark - 通用的保存和fetch对象的，通过relation表
/********************************************/
//通用函数------begin
/********************************************/
/**
 *  存储相关的UMComModelObject的对象，和对应relationID的relation表
 *
 *  @param type              @see UMComRelatedIDTableType
 *  @param umComModelObjects 继承UMComModelObject的类型对象
 */
-(void)saveRelatedIDTableWithType:(UMComRelatedIDTableType)type withUMComModelObjects:(NSArray*)umComModelObjects;
/**
 *  同步查找属于type类型的数据流(包括 feed, user 等)
 *
 *  @param type @see UMComRelatedIDTableType
 *
 *  @return 返回一个包含字典的数组
 */
-(id)fetchSyncWithType:(UMComRelatedIDTableType)type;

/**
 *  异步查找相关的type类型的对象
 *
 *  @param type          @see UMComRelatedIDTableType
 *  @param completeBlock 异步回调,数组类型
 */
-(void)fetchASyncWithType:(UMComRelatedIDTableType)type withCompleteBlock:(void(^)(id,NSError*))completeBlock;


/**
 *  异步删除UMComRelatedIDTableType对应的relationID表的数据
 *
 *  @param type @see UMComRelatedIDTableType
 *  @discuss 此函数只是删除了UMComRelatedIDTableType对应的relationID的表，并没有删除relationID对应的对象的表
 */
-(void)deleteRelatedIDTableWithType:(UMComRelatedIDTableType)type;

/********************************************/
//通用函数------end
/********************************************/

#pragma mark - 更新单独的对象的relation关系

/**
 *  更新相应的feed下面的relation的关系
 *
 *  @param feed @see UMComFeed
 *  @dicuss 此函数会先保存feed,再根据对应feed的相应的关系来更新feed的relation关系的表
 *  @dicuss 一般如果relation关系不变，不需要条用此函数，影响数据库的多余的操作。
 */
-(void)updateRelationWithUMComFeed:(UMComFeed*)feed;
-(void)updateRelationWithUMComUser:(UMComUser*)user;
-(void)updateRelationWithUMComTopic:(UMComTopic*)topic;
-(void)updateRelationWithUMComTopicType:(UMComTopicType*)topicType;
-(void)updateRelationWithUMComMedal:(UMComMedal*)medal;
-(void)updateRelationWithUMComImageUrl:(UMComImageUrl*)imageUrl;
-(void)updateRelationWithUMComComment:(UMComComment*)comment;
-(void)updateRelationWithUMComAlbum:(UMComAlbum*)album;
-(void)updateRelationWithUMComLike:(UMComLike*)like;
-(void)updateRelationWithUMComNotification:(UMComNotification*)notification;
-(void)updateRelationWithUMComPrivateMessage:(UMComPrivateMessage*)privateMessage;
-(void)updateRelationWithUMComPrivateLetter:(UMComPrivateLetter*)privateLetter;

#pragma mark - 单独删除对象

/**
 *  删除feed
 *
 *  @param feed @see UMComFeed
 *  @discuss 删除操作只是把当前的feed的status置为3(如果用户没有设置的话)，
 */
-(void)deleteUMComFeed:(UMComFeed*)feed;
/**
 *  删除user
 *
 *  @param user @see UMComUser
 *  @discuss 删除操作只是把当前的user的status置为3(如果用户没有设置的话)
 */
-(void)deleteUMComUser:(UMComUser*)user;

/**
 *  删除topic
 *
 *  @param topic @see UMComTopic
 *  @discuss 删除操作会删除其reltion表的关系，并删除topicID代表的那一行数据
 */
-(void)deleteUMComTopic:(UMComTopic*)topic;

/**
 *  删除话题类别
 *
 *  @param topicType @see UMComTopicType
 *  @discuss 删除操作会删除UMComTopicType的唯一ID代表的行
 */
-(void)deleteUMComTopicType:(UMComTopicType*)topicType;

/**
 *  删除勋章
 *
 *  @param medal @see UMComMedal
 *  @discuss 删除操作会删除UMComMedal的唯一ID代表的行
 */
-(void)deleteUMComMedal:(UMComMedal*)medal;

/**
 *  删除图片
 *
 *  @param imageUrl @see UMComImageUrl
 *  @discuss 删除操作会删除UMComImageUrl的唯一ID代表的行
 */
-(void)deleteUMComImageUrl:(UMComImageUrl*)imageUrl;

/**
 *  删除评论
 *
 *  @param comment @see UMComComment
 *  @discuss 删除操作只是把当前的user的status置为3
 */
-(void)deleteUMComComment:(UMComComment*)comment;

/**
 *  删除相册
 *
 *  @param album @see UMComAlbum
 *  @discuss 删除操作会删除UMComAlbum的唯一ID代表的行
 */
-(void)deleteUMComAlbum:(UMComAlbum*)album;

/**
 *  删除点赞
 *
 *  @param like @see UMComLike
 *  @discuss 删除操作只是把当前的user的status置为3
 */
-(void)deleteUMComLike:(UMComLike*)like;

/**
 *  删除通知
 *
 *  @param notification @see UMComNotification
 *  @discuss 删除操作会删除UMComNotification的唯一ID代表的行
 */
-(void)deleteUMComNotification:(UMComNotification*)notification;

/**
 *  删除私有消息
 *
 *  @param privateMessage @see UMComPrivateMessage
 *  @discuss 删除操作会删除UMComPrivateMessage的唯一ID代表的行
 */
-(void)deleteUMComPrivateMessage:(UMComPrivateMessage*)privateMessage;

/**
 *  删除私有回话Letter
 *
 *  @param privateLetter @see UMComPrivateLetter
 *  @discuss 删除操作会删除UMComPrivateLetter的唯一ID代表的行
 */
-(void)deleteUMComPrivateLetter:(UMComPrivateLetter*)privateLetter;

#pragma mark - 根据ID查找单一的对象
/**
 *  根据feedID来查找数据库是否存在feed
 *
 *  @param feedID 唯一代表feed的数据
 *
 *  @return 数据库有值就返回UMComfeed的对象，没有返回nil
 */
-(id)fetchSyncUMComFeedWithFeedID:(NSString*)feedID;
-(void)fetchASyncUMComFeedWithFeedID:(NSString*)feedID withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  根据uid来查找数据库是否存在user
 *
 *  @param uid 唯一代表user的数据
 *
 *  @return 数据库有值就返回UMComUser的对象，没有返回nil
 */
-(id)fetchSyncUMComUserWithUID:(NSString*)uid;
-(void)fetchASyncUMComUserWithUID:(NSString*)uid withCompleteBlock:(void(^)(id,NSError*))completeBlock;


/**
 *  根据topicID来查找数据库是否存在topic
 *
 *  @param topicID 唯一代表topic的数据
 *
 *  @return 数据库有值就返回UMComTopic的对象，没有返回nil
 */
-(id)fetchSyncUMComTopicWithTopicID:(NSString*)topicID;
-(void)fetchASyncUMComTopicWithTopicID:(NSString*)topicID withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  根据categoryID来查找数据库是否存在UMComTopicType
 *
 *  @param categoryID 唯一代表UMComTopicType的数据
 *
 *  @return 数据库有值就返回UMComTopicType的对象，没有返回nil
 */
-(id)fetchSyncUMComTopicTypeWithCategoryID:(NSString*)categoryID;
-(void)fetchASyncUMComTopicTypeWithCategoryID:(NSString*)categoryID withCompleteBlock:(void(^)(id,NSError*))completeBlock;


/**
 *  根据medal_id来查找数据库是否存在UMComMedal
 *
 *  @param medal_id 唯一代表UMComMedal的数据
 *
 *  @return 数据库有值就返回UMComMedal的对象，没有返回nil
 */
-(id)fetchSyncUMComMedalWithMedal_id:(NSString*)medal_id;
-(void)fetchASyncUMComMedalWithMedal_id:(NSString*)medal_id withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  根据image_url_id来查找数据库是否存在UMComImageUrl
 *
 *  @param image_url_id 唯一代表UMComImageUrl的数据
 *
 *  @return 数据库有值就返回UMComImageUrl的对象，没有返回nil
 */
-(id)fetchSyncUMComImageUrlWithImage_url_id:(NSString*)image_url_id;
-(void)fetchASyncUMComImageUrlWithImage_url_id:(NSString*)image_url_id withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  根据commentID来查找数据库是否存在UMComComment
 *
 *  @param commentID 唯一代表UMComComment的数据
 *
 *  @return 数据库有值就返回UMComComment的对象，没有返回nil
 */
-(id)fetchSyncUMComCommentWithCommentID:(NSString*)commentID;
-(void)fetchASyncUMComCommentWithCommentID:(NSString*)commentID withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  根据albumID来查找数据库是否存在UMComAlbum
 *
 *  @param albumID 唯一代表UMComAlbum的数据
 *
 *  @return 数据库有值就返回UMComAlbum的对象，没有返回nil
 */
-(id)fetchSyncUMComAlbumWithAlbumID:(NSString*)albumID;
-(void)fetchASyncUMComAlbumWithAlbumID:(NSString*)albumID withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  根据likeID来查找数据库是否存在UMComLike
 *
 *  @param likeID 唯一代表UMComLike的数据
 *
 *  @return 数据库有值就返回UMComLike的对象，没有返回nil
 */
-(id)fetchSyncUMComLikeWithLikeID:(NSString*)likeID;
-(void)fetchASyncUMComLikeWithLikeID:(NSString*)likeID withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  根据notificationID来查找数据库是否存在UMComNotification
 *
 *  @param notificationID 唯一代表UMComNotification的数据
 *
 *  @return 数据库有值就返回UMComNotification的对象，没有返回nil
 */
-(id)fetchSyncUMComNotificationWithNotificationID:(NSString*)notificationID;
-(void)fetchASyncUMComNotificationWithNotificationID:(NSString*)notificationID withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  根据message_id来查找数据库是否存在UMComPrivateMessage
 *
 *  @param message_id 唯一代表UMComPrivateMessage的数据
 *
 *  @return 数据库有值就返回UMComPrivateMessage的对象，没有返回nil
 */
-(id)fetchSyncUMComPrivateMessageWithMessage_id:(NSString*)message_id;
-(void)fetchASyncUMComPrivateMessageWithMessage_id:(NSString*)message_id withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  根据letter_id来查找数据库是否存在UMComPrivateLetter
 *
 *  @param letter_id 唯一代表UMComPrivateLetter的数据
 *
 *  @return 数据库有值就返回UMComPrivateLetter的对象，没有返回nil
 */
-(id)fetchSyncUMComPrivateLetterWithLetter_id:(NSString*)letter_id;
-(void)fetchASyncUMComPrivateLetterWithLetter_id:(NSString*)letter_id withCompleteBlock:(void(^)(id,NSError*))completeBlock;

#pragma mark - 保存和提取特定接口的对应的relation关系表
/**
 *  保存(提取)社区最热的feed和相应的关系表
 *
 *  @param hotDay 最热的天数
 *  @param feeds  feed的数组
 *  @dicuss 该保存函数只是保存了当前存入的array的数据，用于第一页面的缓存，不提供分页功能
 */
-(void)saveCommunityHotFeedWithHotDay:(NSInteger)hotDay withFeeds:(NSArray*)feeds;
-(id)fetchSyncCommunityHotFeedWithHotDay:(NSInteger)hotday;
-(void)fetchASyncCommunityHotFeedWithHotDay:(NSInteger)hotday withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  保存(提取)话题下最新发布的feed和相应的关系表
 *
 *  @param topicID 对应的topicID
 *  @param feeds   feed的数组
 *  @dicuss 该保存函数只是保存了当前存入的array的数据，用于第一页面的缓存，不提供分页功能
 */
-(void)saveRelatedLatestFeedIDInTopicWithTopicID:(NSString*)topicID withFeeds:(NSArray*)feeds;
-(id)fetchSyncRelatedLatestFeedIDInTopicWithTopicID:(NSString*)topicID;
-(void)fetchASyncRelatedLatestFeedIDInTopicWithTopicID:(NSString*)topicID withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  保存(提取)话题下最后回复的feed和相应的关系表
 *
 *  @param topicID 对应的topicID
 *  @param feeds   feed的数组
 *  @dicuss 该保存函数只是保存了当前存入的array的数据，用于第一页面的缓存，不提供分页功能
 */
-(void)saveRelatedLastReplyFeedIDInTopicWithTopicID:(NSString*)topicID withFeeds:(NSArray*)feeds;
-(id)fetchSyncRelatedLastReplyFeedIDInTopicWithTopicID:(NSString*)topicID;
-(void)fetchASyncRelatedLastReplyFeedIDInTopicWithTopicID:(NSString*)topicID withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  保存(提取)话题下推荐的feed和相应的关系表
 *
 *  @param topicID 对应的topicID
 *  @param feeds   feed的数组
 *  @dicuss 该保存函数只是保存了当前存入的array的数据，用于第一页面的缓存，不提供分页功能
 */
-(void)saveRelatedRecommendFeedIDInTopicWithTopicID:(NSString*)topicID withFeeds:(NSArray*)feeds;
-(id)fetchSyncRelatedRecommendFeedIDInTopicWithTopicID:(NSString*)topicID;
-(void)fetchASyncRelatedRecommendFeedIDInTopicWithTopicID:(NSString*)topicID withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  保存(提取)话题下最热的feed和相应的关系表
 *
 *  @param topicID 对应的topicID
 *  @param hotDay  最热的天数
 *  @param feeds   feed的数组
 *  @dicuss 该保存函数只是保存了当前存入的array的数据，用于第一页面的缓存，不提供分页功能
 */
-(void)saveRelatedHotFeedIDInTopicWithTopicID:(NSString*)topicID withHotDay:(NSInteger)hotDay withFeeds:(NSArray*)feeds;
-(id)fetchSyncRelatedHotFeedIDInTopicWithTopicID:(NSString*)topicID withHotDay:(NSInteger)hotDay;
-(void)fetchASyncRelatedHotFeedIDInTopicWithTopicID:(NSString*)topicID withHotDay:(NSInteger)hotDay withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  保存(提取)对应的uid的相册(个人中心用)
 *
 *  @param uid    对应的uid
 *  @param albums 相册的数组
 *  @dicuss 该保存函数只是保存了当前存入的array的数据，用于第一页面的缓存，不提供分页功能
 */
-(void)saveRelatedAlbumIDWithUID:(NSString*)uid withAlbums:(NSArray*)albums;
-(id)fetchSyncRelatedAlbumIDWithUID:(NSString*)uid;
-(void)fetchASyncRelatedAlbumIDWithUID:(NSString*)uid withCompleteBlock:(void(^)(id,NSError*))completeBlock;


/**
 *  保存(提取)对应uid的topic(个人中心用)
 *
 *  @param uid    对应的uid
 *  @param topics 话题的数组
 *  @dicuss 该保存函数只是保存了当前存入的array的数据，用于第一页面的缓存，不提供分页功能
 */
-(void)saveRelatedTopicIDWithUID:(NSString*)uid withTopics:(NSArray*)topics;
-(id)fetchSyncRelatedTopicIDWithUID:(NSString*)uid;
-(void)fetchASyncRelatedTopicIDWithUID:(NSString*)uid withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  保存(提取)对应uid的feed(个人中心用)
 *
 *  @param uid    对应的uid
 *  @param feeds feed的数组
 *  @dicuss 该保存函数只是保存了当前存入的array的数据，用于第一页面的缓存，不提供分页功能
 */
-(void)saveRelatedFeedIDWithUID:(NSString*)uid withFeeds:(NSArray*)feeds;
-(id)fetchSyncRelatedFeedIDWithUID:(NSString*)uid;
-(void)fetchASyncRelatedFeedIDWithUID:(NSString*)uid withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  保存(提取)对应uid的关注的user(个人中心用)
 *
 *  @param uid    对应的uid
 *  @param users  user的数组
 *  @dicuss 该保存函数只是保存了当前存入的array的数据，用于第一页面的缓存，不提供分页功能
 */
-(void)saveRelatedFollowerUIDWithUID:(NSString*)uid withUsers:(NSArray*)users;
-(id)fetchSyncRelatedFollowerUIDWithUID:(NSString*)uid;
-(void)fetchASyncRelatedFollowerUIDWithUID:(NSString*)uid withCompleteBlock:(void(^)(id,NSError*))completeBlock;

/**
 *  保存(提取)对应uid下对应的fan的user(个人中心用)
 *
 *  @param uid    对应的uid
 *  @param users  user的数组
 *  @dicuss 该保存函数只是保存了当前存入的array的数据，用于第一页面的缓存，不提供分页功能
 */
-(void)saveRelatedFanUIDWithUID:(NSString*)uid withUsers:(NSArray*)users;
-(id)fetchSyncRelatedFanUIDWithUID:(NSString*)uid;
-(void)fetchASyncRelatedFanUIDWithUID:(NSString*)uid withCompleteBlock:(void(^)(id,NSError*))completeBlock;

@end
