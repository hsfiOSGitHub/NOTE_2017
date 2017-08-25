//
//  NSDictionary+Tool.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Tool)

/**
 *  以NSString类型将字典本身转换为JSON
 *
 *  @return 返回NSString类型的JSON或者当解析错误时返回nil
 */
- (NSString * _Nonnull)dictionaryToJSON;

/**
 *  将给出的字典转换为NSString类型的JSON
 *
 *  @param dictionary 需要被转换的字典
 *
 *  @return 返回NSString类型的JSON或者当解析错误时返回nil
 */
+ (NSString * _Nonnull)dictionaryToJSON:(NSDictionary * _Nonnull)dictionary;

/**
 *  如果key存在返回对应的对象，否则返回nil
 *
 *  @param key 键值
 *
 *  @return Value值，否则nil
 */
- (id _Nullable)safeObjectForKey:(NSString * _Nonnull)key;

@end
