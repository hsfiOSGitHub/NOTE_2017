//
//  UMComLike.h
//  UMCommunity
//
//  Created by umeng on 15/7/10.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UMComModelObject.h"

@class UMComFeed, UMComUser;

@interface UMComLike : UMComModelObject

#pragma mark - 固定的base属性

/**
 点赞唯一ID
 */
@property (nonatomic, retain) NSString * id;
/**
 点赞时间
 */
@property (nonatomic, retain) NSString * create_time;

/**
 被点赞的Feed
 */
@property (nonatomic, retain) NSString *feed_id;

/**
 *  内部使用
 */
@property (nonatomic, retain) NSNumber * seq;

/**
 *   0- 正常  1- 被举报 2- 判定垃圾  3- 被删除，用户主动行为 4- 被管理员删除  5- 包含敏感词，被自动过滤 6- 预审核
 */
@property (nonatomic, retain) NSNumber * status;

#pragma mark - 固定的relation属性

/**
 点赞用户
 */
@property (nonatomic, retain) UMComUser *creator;

/**
 被点赞的Feed(在我收到的赞的界面会接收到此字段)
 */
@property (nonatomic, retain) UMComFeed *feed;

#pragma mark - 可变的基本属性(随着情景值会发生变化)

#pragma mark - 可变的relation属性(随着情景值会发生变化)

#pragma mark - 自定义字段

#pragma mark -



@end
