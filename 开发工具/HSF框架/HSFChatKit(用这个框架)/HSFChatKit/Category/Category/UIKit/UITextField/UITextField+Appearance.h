//
//  UITextField+Appearance.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Appearance)

/**
 *  设置UITextField左边距
 *
 *  @param leftWidth 边距
 */
- (void)setTextFieldLeftPadding:(CGFloat)leftWidth;


/**
 设置UITextField 右侧清除按钮图片
 
 @param normalButtonName      常规图片名
 @param highlightedButtonName 高亮图片名
 */
- (void)setTextFieldClearButtonNormal:(NSString *)normalButtonName Highlighted:(NSString *)highlightedButtonName;


/**
 *  设置UITextField Placeholder颜色
 *
 *  @param color 颜色值
 */
- (void)setTextFieldPlaceholderColor:(UIColor *)color;

/**
 *  设置全局共用UITextField对象的指定格式
 *
 *  注意：此是对setTextFieldClearButtonNormal:Highlighted:方法的再封装，需要到.m文件中去自己设置图片
 *
 */
+ (void)setTextFieldSpecifiedformat;

@end
