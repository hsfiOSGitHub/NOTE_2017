//
//  UIImage+color.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/27.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (color)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

//👇这个方法更好用
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
