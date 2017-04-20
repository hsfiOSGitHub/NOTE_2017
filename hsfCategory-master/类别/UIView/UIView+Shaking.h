//
//  UIView+Shaking.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/6.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ShakingDirection) {
    ShakingDirectionHorizontal,
    ShakingDirectionVertical,
};
/*
 * @param times 震动的次数 
 * @param speed 震动的速度 
 * @param range 震动的幅度 
 * @param shakeDirection 哪个方向上的震动 
 * @param currentTimes 当前的震动次数
 * @param direction 向哪边震动 
 */
@interface UIView (Shaking)
//0.1秒抖动一次 弧度为5 抖动10次
- (void)shakeWithShakeDirection:(ShakingDirection)shakeDirection;

- (void)shakeWithTimes:(NSInteger)times shakeDirection:(ShakingDirection)shakeDirection;

- (void)shakeWithTimes:(NSInteger)times speed:(CGFloat)speed shakeDirection:(ShakingDirection)shakeDirection;

- (void)shakeWithTimes:(NSInteger)times speed:(CGFloat)speed range:(CGFloat)range shakeDirection:(ShakingDirection)shakeDirection;
@end
