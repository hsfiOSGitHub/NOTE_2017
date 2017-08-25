//
//  UIView+Border.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/23.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "UIView+Border.h"

@implementation UIView (Border)

- (void)setCornerRadius:(CGFloat)radius {
    self.layer.cornerRadius = radius;
    [self.layer setMasksToBounds:YES];
}

- (void)createBordersWithColor:(UIColor * _Nonnull)color withCornerRadius:(CGFloat)radius andWidth:(CGFloat)width {
    self.layer.borderWidth = width;
    self.layer.cornerRadius = radius;
    self.layer.shouldRasterize = NO;
    self.layer.rasterizationScale = 2;
    self.layer.edgeAntialiasingMask = kCALayerLeftEdge | kCALayerRightEdge | kCALayerBottomEdge | kCALayerTopEdge;
    self.clipsToBounds = YES;
    self.layer.masksToBounds = YES;
    
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGColorRef cgColor = [color CGColor];
    self.layer.borderColor = cgColor;
    CGColorSpaceRelease(space);
}

- (void)removeBorders {
    self.layer.borderWidth = 0;
    self.layer.cornerRadius = 0;
    self.layer.borderColor = nil;
}

@end
