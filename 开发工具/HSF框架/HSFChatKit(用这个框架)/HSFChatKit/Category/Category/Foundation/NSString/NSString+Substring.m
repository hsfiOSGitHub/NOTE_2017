//
//  NSString+Substring.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "NSString+Substring.h"

@implementation NSString (Substring)

+ (NSString * _Nonnull)searchInString:(NSString *)string charStart:(char)charStart charEnd:(char)charEnd {
    int start = 0, end = 0;
    
    for (int i = 0; i < [string length]; i++) {
        if ([string characterAtIndex:i] == charStart && start == 0) {
            start = i+1;
            i += 1;
            continue;
        }
        if ([string characterAtIndex:i] == charEnd) {
            end = i;
            break;
        }
    }
    
    end -= start;
    
    if (end < 0) {
        end = 0;
    }
    
    return [[string substringFromIndex:start] substringToIndex:end];
}

- (NSString * _Nonnull)searchCharStart:(char)start charEnd:(char)end {
    return [NSString searchInString:self charStart:start charEnd:end];
}

- (NSInteger)indexOfCharacter:(char)character {
    for (NSUInteger i = 0; i < [self length]; i++) {
        if ([self characterAtIndex:i] == character) {
            return i;
        }
    }
    
    return -1;
}

- (NSString * _Nonnull)substringFromCharacter:(char)character {
    NSInteger index = [self indexOfCharacter:character];
    if (index != -1) {
        return [self substringFromIndex:index];
    } else {
        return @"";
    }
}

- (NSString * _Nonnull)substringToCharacter:(char)character {
    NSInteger index = [self indexOfCharacter:character];
    if (index != -1) {
        return [self substringToIndex:index];
    } else {
        return @"";
    }
}

- (BOOL)hasString:(NSString * _Nonnull)substring {
    return [self hasString:substring caseSensitive:YES];
}

- (BOOL)hasString:(NSString *)substring caseSensitive:(BOOL)caseSensitive {
    if (caseSensitive) {
        return [self rangeOfString:substring].location != NSNotFound;
    } else {
        return [self.lowercaseString rangeOfString:substring.lowercaseString].location != NSNotFound;
    }
}

- (NSString * _Nonnull)sentenceCapitalizedString {
    if (![self length]) {
        return @"";
    }
    NSString *uppercase = [[self substringToIndex:1] uppercaseString];
    NSString *lowercase = [[self substringFromIndex:1] lowercaseString];
    
    return [uppercase stringByAppendingString:lowercase];
}


@end
