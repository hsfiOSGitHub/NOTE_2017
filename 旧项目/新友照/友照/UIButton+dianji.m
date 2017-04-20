//
//  UIButton+dianji.m
//  友照
//
//  Created by ZX on 17/1/12.
//  Copyright © 2017年 ZX_XPH. All rights reserved.
//

#import "UIButton+dianji.h"

@implementation UIButton (dianji)


- (void)sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if (self.userInteractionEnabled)
    {
        [super sendAction:action to:target forEvent:event];
        self.userInteractionEnabled=NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(),
                       ^{
            self.userInteractionEnabled=YES;
        });
    }
}

@end
