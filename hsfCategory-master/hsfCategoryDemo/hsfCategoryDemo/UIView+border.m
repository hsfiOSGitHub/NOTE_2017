//
//  UIView+border.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/23.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "UIView+border.h"

@implementation UIView (border)

//快速设置边框
-(void)setBorderWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.cornerRadius = cornerRadius;
}

@end
