//
//  UIView+Shadow.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Shadow)

/**
 *  设置当前view的阴影
 *
 *  @param offset  阴影的偏移量
 *  @param opacity 阴影的不透明度
 *  @param radius  阴影的半径
 */
- (void)createRectShadowWithOffset:(CGSize)offset
                           opacity:(CGFloat)opacity
                            radius:(CGFloat)radius;

/**
 *  设置当前view的拐角阴影
 *
 *  @param cornerRadius 拐角半径值
 *  @param offset       阴影的偏移量
 *  @param opacity      阴影的不透明度
 *  @param radius       阴影的半径
 */
- (void)createCornerRadiusShadowWithCornerRadius:(CGFloat)cornerRadius
                                          offset:(CGSize)offset
                                         opacity:(CGFloat)opacity
                                          radius:(CGFloat)radius;

/**
 *  移除当前view的阴影
 */
- (void)removeShadow;

@end
