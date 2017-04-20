//
//  CAShapeLayer+HSFMaskLayer.m
//  友照
//
//  Created by monkey2016 on 16/11/26.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "CAShapeLayer+HSFMaskLayer.h"

@implementation CAShapeLayer (HSFMaskLayer)

//星星评价
+(instancetype)createMaskLayerWithStarView:(UIView *)starView andPercent:(CGFloat)percent{
    CGFloat viewWidth = CGRectGetWidth(starView.frame);
    CGFloat viewHeight = CGRectGetHeight(starView.frame);
    CGPoint point1 = CGPointMake(0, 0);
    CGPoint point2 = CGPointMake(viewWidth * percent, 0);
    CGPoint point3 = CGPointMake(viewWidth * percent, viewHeight);
    CGPoint point4 = CGPointMake(0, viewHeight);
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:point1];
    [path addLineToPoint:point2];
    [path addLineToPoint:point3];
    [path addLineToPoint:point4];
    [path closePath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = path.CGPath;
    return layer;
}

@end
