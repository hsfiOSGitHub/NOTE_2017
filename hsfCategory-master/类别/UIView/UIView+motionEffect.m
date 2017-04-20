//
//  UIView+motionEffect.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "UIView+motionEffect.h"

@implementation UIView (motionEffect)

NSString *const centerX = @"center.x";
NSString *const centerY = @"center.y";

#pragma mark - Motion Effect
- (void)addCenterMotionEffectsXYWithOffset:(CGFloat)offset {
    
    //    if(!IS_OS_7_OR_LATER) return;
    if(floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) return;
    
    UIInterpolatingMotionEffect *xAxis;
    UIInterpolatingMotionEffect *yAxis;
    
    xAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:centerX
                                                            type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    xAxis.maximumRelativeValue = @(offset);
    xAxis.minimumRelativeValue = @(-offset);
    
    yAxis = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:centerY
                                                            type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    yAxis.minimumRelativeValue = @(-offset);
    yAxis.maximumRelativeValue = @(offset);
    
    UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
    group.motionEffects = @[xAxis, yAxis];
    
    [self addMotionEffect:group];
}

@end
