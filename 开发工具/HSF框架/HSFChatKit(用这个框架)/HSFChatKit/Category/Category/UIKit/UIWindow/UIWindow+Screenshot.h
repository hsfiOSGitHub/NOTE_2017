//
//  UIWindow+Screenshot.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWindow (Screenshot)

/**
 *  获取当前window的屏幕截图，不保存至照片专辑中
 *
 *  @return 返回UIImage格式的屏幕截图
 */
- (UIImage * _Nonnull)takeScreenshot;

/**
 *  获取当前window的屏幕截图，并选择是否保存至照片专辑中
 *
 *  @param save YES保存，NO不保存
 *
 *  @return 返回UIImage格式的屏幕截图
 */
- (UIImage * _Nonnull)takeScreenshotAndSave:(BOOL)save;

/**
 *  获取当前window的屏幕截图，并选择是否保存至照片专辑中且延时多久保存
 *
 *  @param delay      延时时间(单位为秒)
 *  @param save       YES保存，NO不保存
 *  @param completion 完成保存后的回调
 */
- (void)takeScreenshotWithDelay:(CGFloat)delay save:(BOOL)save completion:(void (^ _Nullable)(UIImage * _Nonnull screenshot))completion;

@end
