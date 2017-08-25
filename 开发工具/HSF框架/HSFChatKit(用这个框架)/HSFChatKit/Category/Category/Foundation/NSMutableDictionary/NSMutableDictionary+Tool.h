//
//  NSMutableDictionary+Tool.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Tool)

/**
 *  安全的在字典中设置key对应value值
 *
 *  @param anObject value值
 *  @param aKey     key值
 *
 *  @return YES操作成功，NO失败
 */
- (BOOL)safeSetObject:(id _Nonnull)anObject
               forKey:(id<NSCopying> _Nonnull)aKey;

@end
