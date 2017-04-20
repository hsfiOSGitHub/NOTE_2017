//
//  UIView+addToWindow.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "UIView+addToWindow.h"

@implementation UIView (addToWindow)

//将UIView添加到window上
-(void)addToWindow {
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if ([appDelegate respondsToSelector:@selector(window)])
    {
        UIWindow * window = (UIWindow *) [appDelegate performSelector:@selector(window)];
        [window addSubview:self];
    }
}

@end
