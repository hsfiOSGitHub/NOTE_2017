//
//  UIColor+RGB.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/3.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (RGB)

//通过已经有的颜色来获取颜色的RGB值
+ (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color;
@end
