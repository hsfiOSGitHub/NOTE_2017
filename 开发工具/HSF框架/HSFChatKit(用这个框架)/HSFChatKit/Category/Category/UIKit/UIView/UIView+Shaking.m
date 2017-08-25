//
//  UIView+Shaking.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/6.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "UIView+Shaking.h"

@implementation UIView (Shaking)
//0.1秒抖动一次 弧度为5 抖动10次
- (void)shakeWithShakeDirection:(ShakingDirection)shakeDirection {
    [self shakeWithTimes:10 speed:0.05 range:5 shakeDirection:shakeDirection];
}
//0.1秒抖动一次 弧度为5
- (void)shakeWithTimes:(NSInteger)times shakeDirection:(ShakingDirection)shakeDirection {
    [self shakeWithTimes:times speed:0.05 range:5 shakeDirection:shakeDirection];
}
//弧度为5
- (void)shakeWithTimes:(NSInteger)times speed:(CGFloat)speed shakeDirection:(ShakingDirection)shakeDirection {
    [self shakeWithTimes:times speed:speed range:5 shakeDirection:shakeDirection];
}
//指定初始化方法
- (void)shakeWithTimes:(NSInteger)times speed:(CGFloat)speed range:(CGFloat)range shakeDirection:(ShakingDirection)shakeDirection {
    [self viewShakesWithTiems:times speed:speed range:range shakeDirection:shakeDirection currentTimes:0 direction:1];
}
/*
 * @param times 震动的次数
 * @param speed 震动的速度
 * @param range 震动的幅度
 * @param shakeDirection 哪个方向上的震动
 * @param currentTimes 当前的震动次数
 * @param direction 向哪边震动
 */
- (void)viewShakesWithTiems:(NSInteger)times speed:(CGFloat)speed range:(CGFloat)range shakeDirection:(ShakingDirection)shakeDirection currentTimes:(NSInteger)currentTimes direction:(int)direction{
    
    [UIView animateWithDuration:speed animations:^{
        self.transform = (shakeDirection == ShakingDirectionHorizontal)? CGAffineTransformMakeTranslation(range * direction, 0):CGAffineTransformMakeTranslation(0, range * direction);
    } completion:^(BOOL finished) {
        if (currentTimes >= times) {
            [UIView animateWithDuration:speed animations:^{
                self.transform = CGAffineTransformIdentity;
            }];
            return;
        }
#pragma mark - 循环到times == currentTimes时候 会跳出该方法 
        [self viewShakesWithTiems:times - 1
                            speed:speed
                            range:range
                   shakeDirection:shakeDirection
                     currentTimes:currentTimes + 1
                        direction:direction * -1];
    }];
}
@end
