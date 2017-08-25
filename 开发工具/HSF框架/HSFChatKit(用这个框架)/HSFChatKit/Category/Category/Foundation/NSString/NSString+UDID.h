//
//  NSString+UDID.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (UDID)

/**
 *  创建一个UUID字符串
 *
 *  @return 返回被创建的UUID字符串
 */
+ (NSString * _Nonnull)generateUUID;

/**
 *  判断此UUID是否可用
 *
 *  @return YES可用，NO不可用
 */
- (BOOL)isUUID;

/**
 *  判断此UUID对APNS是否可用
 *
 *  @return YES可用，NO不可用
 */
- (BOOL)isUUIDForAPNS;

/**
 *  将自身转换为一个对APNS可用的UUID(No "<>" or "-" or spaces)
 *
 *  @return 返回对APNS可用的UUID(No "<>" or "-" or spaces)
 */
- (NSString * _Nonnull)convertToAPNSUUID;

@end
