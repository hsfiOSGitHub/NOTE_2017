//
//  UIView+Border.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Border)

/**
 *  设置当前view的拐角半径
 *
 *  @param radius 半径值
 */
- (void)setCornerRadius:(CGFloat)radius;

/**
 *  设置当前view的边界周边
 *
 *  @param color  边界的颜色
 *  @param radius 边界的拐角半径
 *  @param width  边界的宽
 */
- (void)createBordersWithColor:(UIColor * _Nonnull)color
              withCornerRadius:(CGFloat)radius
                      andWidth:(CGFloat)width;

/**
 *  移除当前view的边界周边
 */
- (void)removeBorders;

@end
