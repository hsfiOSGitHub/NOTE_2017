//
//  UIImageView+Create.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (Create)

/**
 *  根据指定image和frame创建一个UIImageView
 *
 *  @param image UIImageView image
 *  @param rect  UIImageView frame
 *
 *  @return 返回创建的UIImageView实例
 */
+ (instancetype _Nonnull)initWithImage:(UIImage * _Nonnull)image
                                 frame:(CGRect)rect;

/**
 *  根据指定image、frame、center创建一个UIImageView
 *
 *  @param image  UIImageView image
 *  @param size   UIImageView size
 *  @param center UIImageView center
 *
 *  @return 返回创建的UIImageView实例
 */
+ (instancetype _Nonnull)initWithImage:(UIImage * _Nonnull)image
                                  size:(CGSize)size
                                center:(CGPoint)center;

/**
 *  根据指定image、center创建一个UIImageView
 *
 *  @param image  UIImageView image
 *  @param center UIImageView center
 *
 *  @return 返回创建的UIImageView实例
 */
+ (instancetype _Nonnull)initWithImage:(UIImage * _Nonnull)image
                                center:(CGPoint)center;

/**
 *  根据指定tintColor、image创建一个模板UIImageView
 *
 *  @param image     UIImageView image
 *  @param tintColor UIImageView tint color
 *
 *  @return 返回创建的UIImageView实例
 */
+ (instancetype _Nonnull)initWithImageAsTemplate:(UIImage * _Nonnull)image
                                       tintColor:(UIColor * _Nonnull)tintColor;

@end
