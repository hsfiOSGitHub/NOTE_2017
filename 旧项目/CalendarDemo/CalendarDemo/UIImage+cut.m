//
//  UIImage+cut.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/17.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "UIImage+cut.h"

@implementation UIImage (cut)
//第一种方法
//裁剪图片的函数  
-(UIImage*)cutImageAtSquare:(UIImage*)image Frame:(CGRect)frame{  
    
    UIImage* piePic=nil;  
    
    if(self){   
        //获取截取区域大小  
        CGSize sz=frame.size;  
        //获取截取区域坐标  
        CGPoint origin=frame.origin;  
        //创建sz大小的上下文，背景是否透明：NO，缩放尺寸：0表示不缩放  
        UIGraphicsBeginImageContextWithOptions(sz, NO, 0);  
        //移动坐标原点绘制图片，由于上下文坐标系与图片自身坐标系是相反的，所以绘制坐标需要取反  
        [image drawAtPoint:CGPointMake(-origin.x, -origin.y)];  
        //获取绘制后的图片  
        piePic=UIGraphicsGetImageFromCurrentImageContext();  
        //绘制结束  
        UIGraphicsEndImageContext();  
        
    }  
    return piePic;  
} 
//第二种方法
-(UIImage*)captureView:(UIView *)theView frame:(CGRect)fra{
    UIGraphicsBeginImageContext(theView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef ref = CGImageCreateWithImageInRect(img.CGImage, fra);
    UIImage *i = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    return i;
}


@end
