//
//  NSString+Substring.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Substring)

/**
 *  在指定的字符串中按照开始字符和结束字符获取子字符串
 *  如:"This is a test" with start char 'h' and end char 't' will return "is is a "
 *
 *  @param string 被搜索的字符串
 *  @param start  开始字符
 *  @param end    结束字符
 *
 *  @return 返回子字符串
 */
+ (NSString * _Nonnull)searchInString:(NSString *_Nonnull)string
                            charStart:(char)start
                              charEnd:(char)end;

/**
 *  在字符串本身中按照开始字符和结束字符获取子字符串
 *  如: "This is a test" with start char 'h' and end char 't' will return "is is a "
 *
 *  @param start  开始字符
 *  @param end    结束字符
 *
 *  @return 返回子字符串
 */
- (NSString * _Nonnull)searchCharStart:(char)start
                               charEnd:(char)end;

/**
 *  返回给出字符的索引值(注:返回第一次被找到字符的索引值)
 *
 *  @param character 被搜索的字符
 *
 *  @return 返回被搜索字符的索引值，如果找不到返回-1
 */
- (NSInteger)indexOfCharacter:(char)character;

/**
 *  截取一段从指定字符至末尾的子字符串(注：以找到的第一个字符索引位置开始)
 *
 *  @param character 指定字符
 *
 *  @return 返回从指定字符至末尾的子字符串
 */
- (NSString * _Nonnull)substringFromCharacter:(char)character;

/**
 *  截取一段从头至指定字符的子字符串(注：以找到的第一个字符索引位置开始)
 *
 *  @param character 指定字符
 *
 *  @return 返回从头至指定字符的子字符串
 */
- (NSString * _Nonnull)substringToCharacter:(char)character;

/**
 *  在高敏感度下检查自身是否包含指定的子字符串(区分大小写)
 *st
 *  @param substring 被检查的子字符串
 *
 *  @return YES包含，NO不包含
 */
- (BOOL)hasString:(NSString * _Nonnull)substring;

/**
 *  在指定敏感度下检查自身是否包含自定的子字符串
 *
 *  @param substring     被检查的子字符串
 *  @param caseSensitive YES高敏感度(区分大小写),NO低敏感度(不区分大小写)
 *
 *  @return YES包含，NO不包含
 */
- (BOOL)hasString:(NSString * _Nonnull)substring
    caseSensitive:(BOOL)caseSensitive;


/**
 *  将指定字符串转换为句首大写的标准语法
 *  如: "This is a Test" will return "This is a test" and "this is a test" will return "This is a test"
 *
 *  @return 返回句首大写的字符串
 */
- (NSString * _Nonnull)sentenceCapitalizedString;


@end
