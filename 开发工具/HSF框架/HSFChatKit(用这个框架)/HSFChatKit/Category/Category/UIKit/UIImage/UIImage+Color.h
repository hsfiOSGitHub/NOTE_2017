//
//  UIImage+Color.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

#pragma mark - 图片重绘颜色
/**
 *  纯色图重绘颜色
 *
 *  @param tintColor 目标颜色
 *
 *  @return 重绘颜色后的Image
 */
- (UIImage * _Nonnull)imageWithTintColor:(UIColor * _Nonnull)tintColor;

/**
 *  渐变色图重绘颜色
 *
 *  @param tintColor 目标颜色
 *
 *  @return 重绘颜色后的Image
 */
- (UIImage * _Nonnull)imageWithGradientTintColor:(UIColor * _Nonnull)tintColor;


/**
 *  由颜色生成图片
 *
 *  @param color 目标颜色
 *
 *  @return 重绘颜色后的Image
 */
+ (UIImage *_Nullable) imageWithColor:(UIColor *_Nullable)color;

@end
