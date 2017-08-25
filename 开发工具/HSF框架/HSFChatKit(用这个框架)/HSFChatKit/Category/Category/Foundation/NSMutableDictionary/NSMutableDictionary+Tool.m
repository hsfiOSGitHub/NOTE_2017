//
//  NSMutableDictionary+Tool.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "NSMutableDictionary+Tool.h"

@implementation NSMutableDictionary (Tool)

- (BOOL)safeSetObject:(id _Nonnull)anObject forKey:(id<NSCopying> _Nonnull)aKey {
    if (anObject == nil) {
        return NO;
    }
    
    [self setObject:anObject forKey:aKey];
    
    return YES;
}


@end
