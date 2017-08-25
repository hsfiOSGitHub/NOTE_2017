//
//  NSString+UDID.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "NSString+UDID.h"

@implementation NSString (UDID)

+ (NSString * _Nonnull)generateUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return (__bridge_transfer NSString *)string;
}

- (BOOL)isUUID {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger matches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    return matches == 1;
}

- (BOOL)isUUIDForAPNS {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^[0-9a-f]{32}$" options:NSRegularExpressionCaseInsensitive error:nil];
    NSUInteger matches = [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
    return matches == 1;
}

- (NSString * _Nonnull)convertToAPNSUUID {
    return [[[self stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

@end
