//
//  UMComPointResult.h
//  UMCommunity
//
//  Created by 张军华 on 16/4/29.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "UMComModelObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface UMComPointResult : UMComModelObject
/**
 *  增加或者减少积分的唯一对应的id
 */
@property (nullable, nonatomic, retain) NSString *id;
/**
 *  积分增减的结果
 *  "status": "success",
 */
@property (nullable, nonatomic, retain) NSString *status;

/**
 *  当前用户的总的point(增加add_point后的值)
 */
@property (nullable, nonatomic, retain) NSNumber *cur_point;

/**
 *  用户id
 */
@property (nullable, nonatomic, retain) NSString *uid;

/**
 *  自定义业务ID
 */
@property (nullable, nonatomic, retain) NSString *identity;

/**
 *   当前用户增加的积分数
 */
@property (nullable, nonatomic, retain) NSNumber *add_point;


@end

NS_ASSUME_NONNULL_END

