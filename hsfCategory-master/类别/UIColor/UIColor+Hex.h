//
//  UIColor+Hex.h
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/28.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

/** 从十六进制字符串获取颜色，alpha需要自己传递 color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式 */
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
