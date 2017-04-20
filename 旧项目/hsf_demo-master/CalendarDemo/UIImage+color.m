//
//  UIImage+color.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/27.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "UIImage+color.h"

@implementation UIImage (color)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size  
{  
    CGRect rect = CGRectMake(0, 0, size.width, size.height);  
    UIGraphicsBeginImageContext(rect.size);  
    CGContextRef context = UIGraphicsGetCurrentContext();  
    CGContextSetFillColorWithColor(context,color.CGColor);  
    CGContextFillRect(context, rect);  
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();  
    UIGraphicsEndImageContext();  
    
    return img;  
} 

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f); //宽高 1.0只要有值就够了
    UIGraphicsBeginImageContext(rect.size); //在这个范围内开启一段上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);//在这段上下文中获取到颜色UIColor
    CGContextFillRect(context, rect);//用这个颜色填充这个上下文
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();//从这段上下文中获取Image属性,,,结束
    UIGraphicsEndImageContext();
    
    return image;
}
@end
