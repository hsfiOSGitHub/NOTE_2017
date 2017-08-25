//
//  UIScreen+System.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "UIScreen+System.h"

@implementation UIScreen (System)

+ (BOOL)isRetina {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0 || [UIScreen mainScreen].scale == 3.0)) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)isRetinaHD {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 3.0)) {
        return YES;
    } else {
        return NO;
    }
}

+ (CGFloat)brightness {
    return [UIScreen mainScreen].brightness;
}

+ (void)setBrightness:(CGFloat)brightness {
    [[UIScreen mainScreen] setBrightness:brightness];
}

@end
