//
//  NSNumber+Random.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Random)

/**
 *  在指定范围内创建一个随机integer值
 *
 *  @param minValue 最小随机值
 *  @param maxValue 最大随机值
 *
 *  @return 返回被创建的随机值
 */
+ (NSInteger)randomIntBetweenMin:(NSInteger)minValue
                          andMax:(NSInteger)maxValue;

/**
 *  创建一个随机的float值
 *
 *  @return 返回被创建的随机float值
 */
+ (CGFloat)randomFloat;

/**
 *  在指定范围内创建一个随机float值
 *
 *  @param minValue 最小随机值
 *  @param maxValue 最大随机值
 *
 *  @return 返回被创建的随机值
 */
+ (CGFloat)randomFloatBetweenMin:(CGFloat)minValue
                          andMax:(CGFloat)maxValue;

@end
