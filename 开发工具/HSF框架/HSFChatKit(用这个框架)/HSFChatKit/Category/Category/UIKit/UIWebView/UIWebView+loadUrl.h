//
//  UIWebView+loadUrl.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (loadUrl)


/**
 *  移除当前UIWebView的背景阴影
 */
- (void)removeBackgroundShadow;

/**
 *  加载网址
 *
 *  @param website 需要加载的网址
 */
- (void)loadWebsite:(NSString * _Nonnull)website;

@end
