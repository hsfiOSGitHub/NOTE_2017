//
//  UIBarButtonItem+setting.h
//  HCJ
//
//  Created by JuZhenBaoiMac on 2017/7/13.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (setting)

+ (UIBarButtonItem *)itemWithTargat:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;

@end
