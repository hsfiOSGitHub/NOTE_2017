//
//  NSString+Size.m
//  SuperCar
//
//  Created by JuZhenBaoiMac on 2017/5/19.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)


//获取字符串size
+ (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font maxSize:(CGSize)maxSize{
    if (kStringIsEmpty(string)) {
        return CGSizeZero;
    }
    NSDictionary *dict = @{NSFontAttributeName : font};
    
    CGSize size = [string boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    
    return size;
}


@end
