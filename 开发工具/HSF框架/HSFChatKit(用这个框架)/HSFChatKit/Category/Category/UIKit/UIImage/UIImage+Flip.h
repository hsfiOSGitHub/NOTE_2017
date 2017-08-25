//
//  UIImage+Flip.h
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Flip)


#pragma mark - 翻转图片
/**
 *  水平翻转image
 *
 *  @return 返回翻转后的image
 */
- (UIImage * _Nonnull)flipImageHorizontally;

/**
 *  垂直翻转image
 *
 *  @return 返回翻转后的iamge
 */
- (UIImage * _Nonnull)flipImageVertically;

/**
 *  垂直并水平翻转image
 *
 *  @return 返回翻转后的iamge
 */
- (UIImage * _Nullable)flipImageVerticallyAndHorizontally;

@end
