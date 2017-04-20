//
//  UMComKit+String.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 5/12/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComKit.h"

@interface UMComKit (String)

+ (NSInteger)getStringLengthWithString:(NSString *)string;

+ (BOOL)checkEmailFormat:(NSString *)emailString;

+ (BOOL)includeSpecialCharact:(NSString *)sourceString;

+ (BOOL)includeAlphabetOrDigitOnly:(NSString *)sourceString;

+ (NSString *)md5:(NSString *)sourceString;

/**
 *  解析点击webview的<a>链接的时候字典
 *
 *  @param requestString <a>标签中跳转的href的字段
 *
 *  @return 点击需要的字典类型数据
 */
+(NSDictionary*)parseWebViewRequestString:(NSString*)requestString;

@end
