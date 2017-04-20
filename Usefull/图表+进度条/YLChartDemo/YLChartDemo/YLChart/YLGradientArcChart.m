//
//  YLGradientArcChart.m
//  DrawTest
//
//  Created by LELE on 17/4/12.
//  Copyright © 2017年 rect. All rights reserved.
//

#import "YLGradientArcChart.h"
@interface YLGradientArcChart()
@end
@implementation YLGradientArcChart
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self drawArc];
    }
    return self;
}

-(void)drawArc
{
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat radius = self.frame.size.width * 0.5 - 15;
    UIBezierPath* arcPath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:M_PI endAngle:0 clockwise:YES];
    
    CAShapeLayer* shapelayer = [CAShapeLayer layer];
    shapelayer.lineWidth = 5.0;
    shapelayer.strokeColor = [UIColor clearColor].CGColor;
    shapelayer.fillColor = [UIColor clearColor].CGColor;
    shapelayer.path = arcPath.CGPath;
    [self.layer addSublayer:shapelayer];
    
    UIColor* yellowColor1 =  [UIColor colorWithRed:250.0 / 255.0 green:238.0 / 255.0 blue:145.0 / 255.0 alpha:1.0];
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.backgroundColor = [UIColor blueColor].CGColor;
    [self.layer addSublayer:gradientLayer];
    
    CAGradientLayer* firstLayer = [CAGradientLayer layer];
    firstLayer.frame = CGRectMake(0, 0, self.frame.size.width * 0.5, self.frame.size.height);
    firstLayer.colors = @[(id)[UIColor blueColor].CGColor,(id)yellowColor1.CGColor];
    firstLayer.locations = @[@0.1,@1.0];
    firstLayer.startPoint = CGPointMake(0, 0);
    firstLayer.endPoint = CGPointMake(1, 0);
    [gradientLayer addSublayer:firstLayer];
    
    CAGradientLayer* secondLayer = [CAGradientLayer layer];
    secondLayer.frame = CGRectMake(self.frame.size.width * 0.5, 0, self.frame.size.width * 0.5, self.frame.size.height);
    secondLayer.colors = @[(id)yellowColor1.CGColor,(id)[UIColor redColor].CGColor];
    secondLayer.locations = @[@0,@0.9];
    secondLayer.startPoint = CGPointMake(0, 0);
    secondLayer.endPoint = CGPointMake(1, 0);
    [gradientLayer addSublayer:secondLayer];
    
    CAShapeLayer* gressLayer = [CAShapeLayer layer];
    gressLayer.lineWidth = 10.0;
    gressLayer.strokeColor = [UIColor blueColor].CGColor;
    gressLayer.fillColor = [UIColor clearColor].CGColor;
    gressLayer.lineCap = @"round";
    gressLayer.path = arcPath.CGPath;
    gradientLayer.mask = gressLayer;
    
    CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = 1.5;
    [gressLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
}


@end
