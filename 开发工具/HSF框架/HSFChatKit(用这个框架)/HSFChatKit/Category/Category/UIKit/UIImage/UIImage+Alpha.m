//
//  UIImage+Alpha.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "UIImage+Alpha.h"

@implementation UIImage (Alpha)

#pragma mark - 设置图片alpha
/**
 *  设置图片alpha
 *
 *  @param image 图片
 *  @param alpha alpha
 *
 *  @return 图片
 */
+ (UIImage * _Nonnull)setImageAlpha:(UIImage * _Nonnull)image alpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (BOOL)hasAlpha {
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);
}

- (UIImage * _Nonnull)removeAlpha {
    if (![self hasAlpha]) {
        return self;
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef mainViewContentContext = CGBitmapContextCreate(NULL, self.size.width, self.size.height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(mainViewContentContext, CGRectMake(0, 0, self.size.width, self.size.height), self.CGImage);
    CGImageRef mainViewContentBitmapContext = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    UIImage *returnImage = [UIImage imageWithCGImage:mainViewContentBitmapContext];
    CGImageRelease(mainViewContentBitmapContext);
    
    return returnImage;
}

- (UIImage * _Nonnull)fillAlpha {
    return [self fillAlphaWithColor:[UIColor whiteColor]];
}

- (UIImage * _Nonnull)fillAlphaWithColor:(UIColor * _Nonnull)color {
    CGRect imageRect;
    imageRect.origin = CGPointZero;
    imageRect.size = self.size;
    
    CGColorRef cgColor = [color CGColor];
    
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, cgColor);
    CGContextFillRect(context, imageRect);
    [self drawInRect:imageRect];
    
    UIImage *returnImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return returnImage;
}


@end
