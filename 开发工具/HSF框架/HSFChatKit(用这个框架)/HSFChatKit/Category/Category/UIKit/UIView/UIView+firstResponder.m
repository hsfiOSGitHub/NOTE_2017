//
//  UIView+firstResponder.m
//  KeyboardDemo
//
//  Created by JuZhenBaoiMac on 2017/4/21.
//  Copyright © 2017年 李小龙. All rights reserved.
//

#import "UIView+firstResponder.h"

@implementation UIView (firstResponder)

- (UIView *)firstResponderView {
    
    if([self isFirstResponder]) {
        return self;
    }
    
    for (UIView *subView in self.subviews) {
        UIView *firstResponder = [subView firstResponderView];
        if(firstResponder) {
            return firstResponder;
        }
    }
    return nil;
    
}

@end
