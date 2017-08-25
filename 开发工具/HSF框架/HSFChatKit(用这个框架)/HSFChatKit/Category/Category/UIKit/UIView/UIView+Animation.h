//
//  UIView+Animation.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Animation)

/**
 *  为当前view创建震动动画效果
 */
- (void)shakeView;

/**
 *  为当前view创建脉冲动画效果
 *
 *  @param duration 动画时间
 */
- (void)pulseViewWithDuration:(CGFloat)duration;

/**
 *  为当前view创建心跳动画效果
 *
 *  @param duration 动画时间
 */
- (void)heartbeatViewWithDuration:(CGFloat)duration;

/**
 *  为当前view增加运行效果
 */
- (void)applyMotionEffects;

@end
