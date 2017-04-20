//
//  UMComPointDetail.h
//  UMCommunity
//
//  Created by 张军华 on 16/4/29.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComModelObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface UMComPointDetail : UMComModelObject

/**
 *  用户id
 */
@property (nullable, nonatomic, retain) NSString *user_id;

/**
 *  修改时间
 */
@property (nullable, nonatomic, retain) NSString *modify_time;

/**
 *  行为产生积分变化值
 */
@property (nullable, nonatomic, retain) NSNumber *add_point;

/**
 *  当前的积分
 */
@property (nullable, nonatomic, retain) NSNumber *cur_point;

/**
 *  表示用户对当前积分产生的行为，用户可以自定义其作用
 *  @dicuss action的取值和相应的rel_id的含义(此字段)
 *  ForExample:
 *  当action = @"FEED"时,rel_id为feed的id
 *  当action = @"COMMENT_FEED"时,rel_id为comment的id
 */
@property (nullable, nonatomic, retain) NSString *action;

/**
 *  表示原因
 */
@property (nullable, nonatomic, retain) NSString *cause;

/**
 *  社区id
 */
@property (nullable, nonatomic, retain) NSString *community_id;

/**
 *  当前的唯一id
 */
@property (nullable, nonatomic, retain) NSString *id;

/**
 *  关联action的id
 *  当action = @"FEED"时,rel_id为feed的id
 *  当action = @"COMMENT_FEED"时,rel_id为comment的id
 */
@property (nullable, nonatomic, retain) NSString *rel_id;

@end

NS_ASSUME_NONNULL_END

