//
//  UIImage+Color.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

#pragma mark - 图片重绘颜色
- (UIImage *_Nonnull)imageWithTintColor:(UIColor *_Nonnull)tintColor
{
    //kCGBlendModeDestinationIn  保留透明度信息并绘制成目标色
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *_Nonnull)imageWithGradientTintColor:(UIColor *_Nonnull)tintColor
{
    //kCGBlendModeOverlay  保留灰度信息（比如图片阴影部分等）
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *_Nonnull)imageWithTintColor:(UIColor *_Nonnull)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tintedImage;
}


+ (UIImage*) imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData* imageData = UIImageJPEGRepresentation(image, 1.0f);
    image = [UIImage imageWithData:imageData];
    return image;
}


@end
