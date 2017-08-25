//
//  UIImage+Alpha.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Alpha)

#pragma mark - 设置图片alpha
/**
 *  设置图片alpha
 *
 *  @param image 图片
 *  @param alpha alpha
 *
 *  @return 图片
 */
+ (UIImage * _Nonnull)setImageAlpha:(UIImage * _Nonnull)image alpha:(CGFloat)alpha;

/**
 *  检查image是否有alpha属性
 *
 *  @return Returns YES有，NO无
 */
- (BOOL)hasAlpha;

/**
 *  移除image的alpha属性
 *
 *  @return 没有alpha属性的image
 */
- (UIImage * _Nonnull)removeAlpha;

/**
 *  使用白色填充alpha属性
 *
 *  @return 填充后的image
 */
- (UIImage * _Nonnull)fillAlpha;

/**
 *  使用指定color填充alpha属性
 *
 *  @param color 指定的color
 *
 *  @return 填充指定颜色alpha属性后的图片
 */
- (UIImage * _Nonnull)fillAlphaWithColor:(UIColor * _Nonnull)color;


@end
