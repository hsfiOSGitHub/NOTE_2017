//
//  UIToolbar+transparent.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "UIToolbar+transparent.h"

@implementation UIToolbar (transparent)

- (void)setTransparent:(BOOL)transparent {
    if (transparent) {
        [self setBackgroundImage:[UIImage new] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
    } else {
        [self setBackgroundImage:nil forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self setShadowImage:nil forToolbarPosition:UIBarPositionAny];
    }
}

@end
