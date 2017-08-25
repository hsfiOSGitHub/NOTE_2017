//
//  UIImage+Resize.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resize)

/**
 *  将图片剪裁至目标尺寸(将图片直接重绘入目标尺寸画布，原长/宽比例为目标尺寸长/宽比例)
 *
 *  @param targetSize 目标size
 *
 *  @return 返回处理后的image
 */
- (UIImage * _Nullable)imageByScalingToSize:(CGSize)targetSize;

/**
 *  将图片剪裁至目标尺寸(将图片按比例压缩后重绘入目标尺寸画布，并裁剪掉多余部分，原长/宽比例不变)
 *
 *  @param targetSize 目标size
 *
 *  @return 返回处理后的image
 */
- (UIImage * _Nullable)imageByScalingAndCroppingToTargetSize:(CGSize)targetSize;


/**
 * 内切处理图片
 *
 *  @param insets 内切值
 *
 *  @return 返回处理后的image
 */
- (UIImage * _Nonnull)edgeInsetsImage:(UIEdgeInsets)insets;

/**
 * 按比例拉伸/缩放图片
 *
 *  @param scale 拉伸/缩放 比例
 *
 *  @return 返回处理后的image
 */
- (UIImage * _Nullable)imageByResizeToScale:(CGFloat)scale;

/**
 * 按目标尺寸以最大边缩小图片
 * 若给出的size.width和size.height均大于图片原本原本的宽和高，则返回原图
 *
 *  @param size 目标缩小尺寸
 *
 *  @return 返回处理后的image
 */
- (UIImage * _Nullable)imageByNarrowWithMaxSize:(CGSize)size;

@end
