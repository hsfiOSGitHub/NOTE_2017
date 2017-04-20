//
//  UMComFeed.h
//  UMCommunity
//
//  Created by umeng on 15/11/6.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComModelObject.h"

#define FeedStatusDeleted 2

@class UMComComment, UMComLike, UMComTopic, UMComUser,UMComImageUrl, UMComLocation;


@interface UMComFeed : UMComModelObject

#pragma mark - 固定的base属性
/** feedID feed的唯一ID */
@property (nonatomic, retain) NSString * feedID;
/** feed的内容 */
@property (nonatomic, retain) NSString * text;
/** feed标题 */
@property (nonatomic, retain) NSString * title;

/** feed状态，大于或等与2表示已被删除，小于2表示正常 */
/*0- 正常  1- 被举报 2- 判定垃圾  3- 被删除，用户主动行为 4- 被管理员删除  5- 包含敏感词，被自动过滤 6- 预审核*/
@property (nonatomic, retain) NSNumber * status;
/** 是否已经点赞 */
@property (nonatomic, retain) NSNumber * liked;
/** 点赞个数 */
@property (nonatomic, retain) NSNumber * likes_count;
/** 评论个数 */
@property (nonatomic, retain) NSNumber * comments_count;
/**内部使用(目前没有用到) */
@property (nonatomic, retain) NSNumber * seq;
/** 转发个数 */
@property (nonatomic, retain) NSNumber * forward_count;
/** 用于判断是否可以对Feed创建者禁言,值为1表示可以禁言，值为0表示不能禁言 */
@property (nonatomic, retain) NSNumber *ban_user;
/** 是否是全局置顶 */
@property (nonatomic, retain) NSNumber * is_top;
/** 判断Feed是否为精华，0为普通，1为精华 */
@property (nonatomic, retain) NSNumber *  tag;
/** feed类型，1表示公告，0表示普通 */
@property (nonatomic, retain) NSNumber * type;
/** 创建时间 */
@property (nonatomic, retain) NSString * create_time;
/*内部使用(目前没用)*/
@property (nonatomic, retain) NSNumber * user_mark;
/** 是否收藏 */
@property (nonatomic, retain) NSNumber * has_collected;
/** 字段值为111（Feed全部权限）或者100（删除feed权限）目前只有这两种权限可以操作feed,值为0则没有任何相关权限 */
@property (nonatomic, retain) NSNumber *permission;

/** 转发Feed的id，如果Feed不是转发，则为空 */
@property (nonatomic, retain) NSString * parent_feed_id;
/** 原始Feed的id，如果Feed不是转发，则为空 */
@property (nonatomic, retain) NSString * origin_feed_id;

/** 自定义字段(创建Feed的时候加自定义的内容) */
@property (nonatomic, retain) NSString * custom;

/** 文本类型 0:普通文本, 1:富文本, 2:视频*/
@property (nonatomic, retain) NSNumber * media_type;

/** 是否推荐 BOLL类型 */
@property (nonatomic, retain) NSNumber * is_recommended;

/** 分享链接 */
@property (nonatomic, retain) NSString * share_link;


//富文本相关 since version 2.5.0
/** 富文本的内容 media_type = 1的时候有值*/
@property (nonatomic, retain) NSString * rich_text;
/** 富文本的url(此url是请求服务器的来获得富文本的内容) media_type = 1的时候有值*/
@property (nonatomic, retain) NSString * rich_text_url;

#pragma mark - 固定的relation属性
/*地理位置*/
@property (nonatomic, retain) UMComLocation* location;
/**  Feed相关用户*/
@property (nonatomic, retain) NSArray *related_user;
/** feed创建者 */
@property (nonatomic, retain) UMComUser *creator;
/** feed图片url数组 保存的对象为`UMComImageUrl` */
@property (nonatomic, retain) NSArray *image_urls;

/** 原始Feed，如果Feed不是转发，则为空 */
@property (nonatomic, retain) UMComFeed *origin_feed;

/** Feed所属的话题 */
@property (nonatomic, retain) NSArray *topics;


#pragma mark - 可变的基本属性(随着情景值会发生变化)
/*是否话题置顶*/
@property (nonatomic, retain) NSNumber * is_topic_top;

/** 距离（在获取附近的Feed`UMComNearbyFeedsRequest`的时候返回） */
@property (nonatomic, retain) NSNumber * distance;


/** 分享次数 */
@property (nonatomic, retain) NSNumber * share_count;

/** 保留字段 */
@property (nonatomic, retain) NSNumber * source_mark;

#pragma mark - 可变的relation属性(随着情景值会发生变化)


#pragma mark - 额外增加的属性用来特定接口判断(新增加字段，不属于协议默认字段)

/**
 *通过用户名从feed相关用户中查找对应的用户
 
 @param name 用户名
 *return 返回一个UMComUser对象
 */
- (UMComUser *)relatedUserWithUserName:(NSString *)name;

/**
 *通过话题名称从feed中查找对应的话题
 
 @param topicName 话题名称
 *return 返回一个UMComTopic对象
 */
- (UMComTopic *)relatedTopicWithTopicName:(NSString *)topicName;

/**
 *判断Feed是否已被标记为删除了
 *return 如果Feed已被删除则返回YES，否则返回NO
 */
- (BOOL)isStatusDeleted;




@end


