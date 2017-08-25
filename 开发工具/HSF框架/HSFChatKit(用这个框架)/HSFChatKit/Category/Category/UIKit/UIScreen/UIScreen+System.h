//
//  UIScreen+System.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScreen (System)

/**
 *  检查当前设备是否是视网膜显示屏
 *
 *  @return YES视网膜显示屏，NO非视网膜显示屏
 */
+ (BOOL)isRetina;

/**
 *  检查当前设备是否是视网膜高清显示屏
 *
 *  @return YES视网膜高清显示屏，NO非视网膜高清显示屏
 */
+ (BOOL)isRetinaHD;


/**
 *  获取当前设备的亮度
 *
 *  @return 返回当前设备的亮度
 */
+ (CGFloat)brightness;

/**
 *  设置当前设备的亮度
 *
 *  @param brightness 新的亮度值
 */
+ (void)setBrightness:(CGFloat)brightness;

@end
