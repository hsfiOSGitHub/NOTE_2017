//
//  UIColor+Modify.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 15/1/2.
//  Copyright (c) 2015年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Modify)
- (UIColor *)invertedColor;                  //> 相对的颜色
- (UIColor *)colorForTranslucency;           //> 半透明颜色
- (UIColor *)lightenColor:(CGFloat)lighten;  //> 亮化的颜色
- (UIColor *)darkenColor:(CGFloat)darken;    //> 暗化的颜色
@end
