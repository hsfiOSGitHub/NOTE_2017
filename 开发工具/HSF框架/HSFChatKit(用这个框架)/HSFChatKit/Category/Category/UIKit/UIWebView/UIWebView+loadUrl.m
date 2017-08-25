//
//  UIWebView+loadUrl.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "UIWebView+loadUrl.h"

@implementation UIWebView (loadUrl)

- (void)removeBackgroundShadow {
    for (UIView *eachSubview in [self.scrollView subviews]) {
        if ([eachSubview isKindOfClass:[UIImageView class]] && eachSubview.frame.origin.x <= 500) {
            eachSubview.hidden = YES;
            [eachSubview removeFromSuperview];
        }
    }
}

- (void)loadWebsite:(NSString * _Nonnull)website {
    [self loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:website]]];
}


@end
