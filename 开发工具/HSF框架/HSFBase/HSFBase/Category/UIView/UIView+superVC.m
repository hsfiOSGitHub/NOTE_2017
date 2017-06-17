//
//  UIView+superVC.m
//  News
//
//  Created by monkey2016 on 16/11/29.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "UIView+superVC.h"

@implementation UIView (superVC)
/** 获取当前view所在的viewController */
- (UIViewController *)getSuperVC{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            UIViewController *vc = (UIViewController *)nextResponder;
            return vc;
        }
    }
    return nil;
}
@end
