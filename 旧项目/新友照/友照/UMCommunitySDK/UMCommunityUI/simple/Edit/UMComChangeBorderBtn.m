//
//  UMComChangeBorderBtn.m
//  UMCommunity
//
//  Created by 张军华 on 16/5/24.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComChangeBorderBtn.h"

@implementation UMComChangeBorderBtn


- (void)touchesBegan:(NSSet<UITouch *> *)touches
           withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    if (self.highlightedBorderColor) {
        
        [self.layer setBorderColor:self.highlightedBorderColor.CGColor];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (self.normalBorderColor) {
        
        [self.layer setBorderColor:self.normalBorderColor.CGColor];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    return;
    //判断是否移动到控件的外面还是内部
    UITouch *touch = [touches anyObject];
    if (![self pointInside:[touch locationInView:self] withEvent:nil]) {
        YZLog(@"touches moved outside the view");
        if (self.normalBorderColor) {
            
            [self.layer setBorderColor:self.normalBorderColor.CGColor];
        }
    }else {
        YZLog(@"touches moved in the view");
        if (self.highlightedBorderColor) {
            
            [self.layer setBorderColor:self.highlightedBorderColor.CGColor];
        }
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    [super touchesCancelled:touches withEvent:event];
    
    if (self.normalBorderColor) {
        
        [self.layer setBorderColor:self.normalBorderColor.CGColor];
    }
}

@end
