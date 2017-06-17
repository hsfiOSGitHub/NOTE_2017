//
//  NSString+Size.h
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/19.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)
//获取字符串size
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize;

@end
