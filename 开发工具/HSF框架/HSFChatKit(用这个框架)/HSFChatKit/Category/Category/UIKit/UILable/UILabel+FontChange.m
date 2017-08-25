//
//  UILabel+FontChange.m
//  LiquoriceDoctorProject
//
//  Created by HenryCheng on 15/12/7.
//  Copyright © 2015年 iMac. All rights reserved.
//

#import "UILabel+FontChange.h"
#import <objc/runtime.h>


//字体样式
#define CustomFontName @"FZLBJW--GB1-0"


#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

//4、5、6 的字体大小用一套字体规范
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
//6、6以上 的字体大小用一套字体规范
#define IS_IPHONE_6Plus (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

/**
 提示：
 目前以7plus 为基准，调整相应的字体大小
 */


@implementation UILabel (FontChange)

+ (void)load {
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获得viewController的生命周期方法的selector
        SEL systemSel = @selector(willMoveToSuperview:);
        //自己实现的将要被交换的方法的selector
        SEL swizzSel = @selector(myWillMoveToSuperview:);
        //两个方法的Method
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            //否则，交换两个方法的实现
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
    });
}
- (void)myWillMoveToSuperview:(UIView *)newSuperview {
    [self myWillMoveToSuperview:newSuperview];
    
    if (self) {
        if (self.tag == 999999) {
            self.font = [UIFont systemFontOfSize:[self changeFontSizeWith:self.font.pointSize]];
        } else {
            if ([UIFont fontNamesForFamilyName:CustomFontName])
                self.font  = [UIFont fontWithName:CustomFontName size:[self changeFontSizeWith:self.font.pointSize]];
        }
    }
}

/**
 提示：
 目前以7plus 为基准，调整相应的字体大小
 */
-(CGFloat)changeFontSizeWith:(CGFloat)originSize{
    CGFloat newSize = originSize;
    
    if (IS_IPAD) {
        newSize = originSize + 2;
    }
    else if (IS_IPHONE) {
        if (IS_IPHONE_4_OR_LESS || IS_IPHONE_5 || IS_IPHONE_6) {
            newSize = originSize - 2;
        }
        else {
            newSize = originSize;
        }
    }
    return newSize;
}




@end
