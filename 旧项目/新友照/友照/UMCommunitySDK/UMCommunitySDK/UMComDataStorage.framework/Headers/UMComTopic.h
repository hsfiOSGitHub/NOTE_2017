//
//  UMComTopic.h
//  UMCommunity
//
//  Created by umeng on 15/11/24.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComModelObject.h"

@class UMComFeed, UMComTopicType, UMComUser, UMComImageUrl,UMComTopicIconUrls;
/**
 *  @brief 用户话题类继承NSManagedObject
 *  
 *  可以直接通过属性或者用koc来访问属性
 */
@interface UMComTopic : UMComModelObject

#pragma mark - 固定的基本属性
/** 话题唯一ID */
@property (nonatomic, retain) NSString * topicID;
/** 话题feed的个数 */
@property (nonatomic, retain) NSNumber * feed_count;
/** 关注话题的人数 */
@property (nonatomic, retain) NSNumber * fan_count;
/** 话题的描述 */
@property (nonatomic, retain) NSString * descriptor;
/** 话题的名称 */
@property (nonatomic, retain) NSString * name;
/** 话题的创建时间 */
@property (nonatomic, retain) NSString * create_time;
/** 话题url */
@property (nonatomic, retain) NSString * icon_url;

/** 暂时无用 */
@property (nonatomic, retain) NSNumber * seq;
/** 暂时无用 */
@property (nonatomic, retain) NSNumber * seq_recommend;

/** 自定义字段 */
@property (nonatomic, retain) NSString * custom;

#pragma mark - 固定的relation属性
/** 保存的是UMComImageUrl对象(扩展字段，给开发者使用) */
@property (nonatomic, retain) NSArray *image_urls;

/** 保存的是UMComTopicIconUrls的对象 话题icon_urls */
@property (nonatomic, retain) UMComTopicIconUrls * icon_urls;

#pragma mark - 可变的基本属性(随着情景值会发生变化)
/** 话题是否关注状态(针对当前登陆用户，如果未登录默认为0) */
@property (nonatomic, retain) NSNumber * is_focused;

/** 话题是否推荐状态(无论是否登陆,都可以在推荐话题里面显示此话题) */
@property (nonatomic, retain) NSNumber * is_recommend;

#pragma mark - 可变的relation属性(随着情景值会发生变化)

#pragma mark - 自定义字段
/** 关联话题类型的字段话题类型 */
@property (nonatomic, retain) NSString* category_id;


@end

