//
//  UIView+border.h
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/23.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (border)

//快速设置边框
-(void)setBorderWithBorderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor cornerRadius:(CGFloat)cornerRadius;

@end
