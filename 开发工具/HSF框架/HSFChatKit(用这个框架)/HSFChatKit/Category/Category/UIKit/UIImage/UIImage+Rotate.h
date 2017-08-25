//
//  UIImage+Rotate.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Rotate)

/**
 *  根据指定radians旋转image
 *
 *  @param radians 目标radians
 *
 *  @return 返回旋转后的image
 */
- (UIImage * _Nonnull)imageRotatedByRadians:(CGFloat)radians;

/**
 *  根据指定degrees旋转image
 *
 *  @param degrees 目标degrees
 *
 *  @return 返回旋转后的image
 */
- (UIImage * _Nonnull)imageRotatedByDegrees:(CGFloat)degrees;

@end
