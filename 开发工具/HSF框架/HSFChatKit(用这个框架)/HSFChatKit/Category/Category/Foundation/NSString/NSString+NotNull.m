//
//  NSString+NotNull.m
//  MJD
//
//  Created by JuZhenBaoiMac on 2017/6/16.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "NSString+NotNull.h"

@implementation NSString (NotNull)

+(instancetype)usefullStrWith:(NSString *)str{
    NSString *newStr = str;
    if (kStringIsEmpty(str)) {
        newStr = @"";
    }
    return newStr;
}

@end
