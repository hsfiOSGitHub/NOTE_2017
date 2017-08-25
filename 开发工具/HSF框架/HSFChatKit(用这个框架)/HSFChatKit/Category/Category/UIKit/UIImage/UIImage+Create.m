//
//  UIImage+Create.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "UIImage+Create.h"

@implementation UIImage (Create)

- (UIImage * _Nonnull)imageAtRect:(CGRect)rect {
    CGRect realRect;
    if (rect.origin.x != 0 && rect.origin.y != 0) {
        realRect = CGRectMake(0, 0, rect.size.width * self.scale, rect.size.height * self.scale);
    } else {
        realRect = CGRectMake(rect.origin.x * self.scale, rect.origin.y * self.scale, rect.size.width * self.scale, rect.size.height * self.scale);
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], realRect);
    UIImage *subImage = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return subImage;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
