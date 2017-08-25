//
//  NSData+Convert.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "NSData+Convert.h"

@implementation NSData (Convert)

+ (NSString * _Nonnull)convertToUTF8String:(NSData * _Nonnull)data {
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (NSString * _Nonnull)convertToUTF8String {
    return [NSData convertToUTF8String:self];
}

+ (NSString * _Nonnull)convertToASCIIString:(NSData * _Nonnull)data {
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

- (NSString * _Nonnull)convertToASCIIString {
    return [NSData convertToASCIIString:self];
}


- (NSString * _Nullable)convertUUIDToString {
    return [[[self description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
