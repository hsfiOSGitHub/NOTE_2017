//
//  UMComCurrencyDetail.h
//  UMCommunity
//
//  Created by 张军华 on 16/4/29.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComModelObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface UMComCurrencyDetail : UMComModelObject

/**
 *  表示用户对当前货币产生的行为,用户可以自定义其作用
 *  @dicuss action的取值和相应的rel_id的含义(此字段)
 *  ForExample:
 *  当action = @"FEED"时,rel_id为feed的id
 *  当action = @"COMMENT_FEED"时,rel_id为comment的id
 
 *
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
 *  用户现有货币
 */
@property (nullable, nonatomic, retain) NSNumber *cur_currency;

/**
 *  行为产生货币变化值
 */
@property (nullable, nonatomic, retain) NSNumber *add_currency;

/**
 *  当前锁定的货币
 */
@property (nullable, nonatomic, retain) NSNumber *lock_currency;

/**
 *  当前CurrencyDetail的唯一id
 */
@property (nullable, nonatomic, retain) NSString *id;

/**
 *  修改时间
 */
@property (nullable, nonatomic, retain) NSString *modify_time;

/**
 *  关联action的id
 *  当action = @"FEED"时,rel_id为feed的id
 *  当action = @"COMMENT_FEED"时,rel_id为comment的id
 */
@property (nullable, nonatomic, retain) NSString *rel_id;

/**
 *  用户id
 */
@property (nullable, nonatomic, retain) NSString *user_id;

@end

NS_ASSUME_NONNULL_END


