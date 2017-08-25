//
//  NSMutableArray+sort.h
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/19.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (sort)

/**
 *  根据自身创建一个倒序的数组
 *
 *  @return 返回倒序数组
 */
- (NSMutableArray * _Nonnull)reversedArray;

/**
 *  根据指定的key对数组进行升序或降序排序
 *
 *  @param key       排序参照key
 *  @param array     被排序处理的数组
 *  @param ascending YES升序，NO降序
 *
 *  @return 返回被处理后的数组
 */
+ (NSMutableArray * _Nonnull)sortArrayByKey:(NSString * _Nonnull)key
                                      array:(NSMutableArray * _Nonnull)array
                                  ascending:(BOOL)ascending;

@end
