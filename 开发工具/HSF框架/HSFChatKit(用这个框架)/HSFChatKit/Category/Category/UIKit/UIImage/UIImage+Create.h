//
//  UIImage+Create.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Create)

/**
 *  根据image本身创建指定rect的image
 *
 *  @param rect 指定的rect
 *
 *  @return 返回指定rect所创建的image
 */
- (UIImage * _Nonnull)imageAtRect:(CGRect)rect;

/**
 *  创建指定color的image
 *
 *  @param color 指定color
 *
 *  @return 返回创建的image
 */
+ (UIImage *)imageWithColor:(UIColor *)color;


@end
