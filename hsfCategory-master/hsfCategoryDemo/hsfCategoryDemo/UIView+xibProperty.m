//
//  UIView+xibProperty.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/28.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "UIView+xibProperty.h"



@implementation UIView (xibProperty)

@dynamic borderWidth;
@dynamic borderColor;
@dynamic cornerRadius;

/**
 * 设置边框宽度
 */
- (void)setBorderWidth:(CGFloat)borderWidth {
    if(borderWidth <0)return;
    
    self.layer.borderWidth = borderWidth;
}

/**
 * 设置边框颜色
 */
- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.borderColor = borderColor.CGColor;
}

/**
 *  设置圆角
 */
- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = cornerRadius >0;
    self.layer.cornerRadius = cornerRadius;
    
}

@end
