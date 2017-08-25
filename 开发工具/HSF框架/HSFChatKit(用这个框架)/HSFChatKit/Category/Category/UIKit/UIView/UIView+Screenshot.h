//
//  UIView+Screenshot.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Screenshot)

/**
 *  获取当前view的屏幕截图
 *
 *  @return 返回UIimage格式的屏幕截图
 */
- (UIImage *) screenshot;

/**
 *  获取当前view的屏幕截图并保存到照片专辑中
 *
 *  @return 返回UIimage格式的屏幕截图
 */
- (UIImage *)saveScreenshot;

/**
 *  获取当前ScrollView contentOffset的屏幕截图
 *
 *  @return 返回UIimage格式的屏幕截图
 */
- (UIImage *) screenshotForScrollViewWithContentOffset:(CGPoint)contentOffset;

/**
 *  View按Rect截图
 *
 *  @return 返回UIimage格式的屏幕截图
 */
- (UIImage *) screenshotInFrame:(CGRect)frame;

@end
