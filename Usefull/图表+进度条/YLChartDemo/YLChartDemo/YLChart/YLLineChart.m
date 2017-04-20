//
//  YLLineChart.m
//  DrawTest
//
//  Created by LELE on 17/4/12.
//  Copyright © 2017年 rect. All rights reserved.
//

#import "YLLineChart.h"
@interface YLLineChart()
@property(nonatomic,strong)NSArray* colors;
@property(nonatomic,assign)BOOL pathCurve;
@end
@implementation YLLineChart

-(instancetype)initWithFrame:(CGRect)frame dataValue:(NSArray *)dataValue colors:(NSArray *)colors pathCurve:(BOOL)pathCurve
{
    if (self == [super initWithFrame:frame]) {
        self.pathCurve = pathCurve;
        self.colors = colors;
        [self drawLine];
        [self setUpLineChart:dataValue];
    }
    return self;
}

-(void)drawLine
{
    CGFloat yLen = 20.0;
    NSInteger yLens = (NSInteger)self.frame.size.height / yLen;
    
    for (int i = 0; i < yLens; i++) {
        UIBezierPath* path = [UIBezierPath bezierPath];
        if (i == yLens - 1) return;
        CGFloat y = self.frame.size.height - 10 - yLen * (i + 1);
        [path moveToPoint:CGPointMake(10, y)];
        [path addLineToPoint:CGPointMake(self.frame.size.width - 20, y)];
        
        CAShapeLayer* shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = self.bounds;
        shapeLayer.lineWidth = 1.0;
        shapeLayer.path = path.CGPath;
        UIColor* color = self.colors[1];
        shapeLayer.strokeColor = color.CGColor;
        shapeLayer.lineDashPattern = @[@2.0];
        [self.layer addSublayer:shapeLayer];

    }

}

-(void)setUpLineChart:(NSArray*)arr
{
    UIBezierPath * pathtemp=[[UIBezierPath alloc] init];
    UIBezierPath * path=[[UIBezierPath alloc] init];
    

    for (int i = 0; i < arr.count; i++ ) {
        NSValue* value = arr[i];
        CGPoint p = value.CGPointValue;
        if (i == 0) {
            [pathtemp moveToPoint:value.CGPointValue];
            [path moveToPoint:value.CGPointValue];
            
        }else{
            if (self.pathCurve) {
                CGPoint nextP = [arr[i-1] CGPointValue];
                CGPoint control1 = CGPointMake(p.x + (nextP.x - p.x) / 2.0, nextP.y );
                CGPoint control2 = CGPointMake(p.x + (nextP.x - p.x) / 2.0, p.y);
                [pathtemp addCurveToPoint:p controlPoint1:control1 controlPoint2:control2];
                [path addCurveToPoint:p controlPoint1:control1 controlPoint2:control2];

            }else{
                [pathtemp addLineToPoint:p];
                [path addLineToPoint:p];
            }
        }
        if (i == arr.count - 1) {
            [path addLineToPoint:CGPointMake(p.x, self.frame.size.height - 10)];
        }
    }
    
    NSMutableArray* colorsA = [NSMutableArray array];
    for (UIColor* color in self.colors) {
        [colorsA addObject:(id)color.CGColor];
    }
    CAShapeLayer *arctemp = [CAShapeLayer layer];
    arctemp.path =pathtemp.CGPath;
    UIColor* color = self.colors.firstObject;
    arctemp.strokeColor = color.CGColor;
    arctemp.fillColor = [UIColor clearColor].CGColor;
    arctemp.lineWidth = 1.0;
    
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    ani.fromValue = @0;
    ani.toValue = @1;
    ani.duration = 3;
    [arctemp addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
    [self.layer addSublayer:arctemp];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [path closePath];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame =self.bounds ;
        gradientLayer.colors = colorsA;
        gradientLayer.locations=@[@0.1,@0.5,@0.8];
        gradientLayer.startPoint = CGPointMake(0,0);
        gradientLayer.endPoint = CGPointMake(0,1);
        [self.layer addSublayer:gradientLayer];
        
        CAShapeLayer *arc = [CAShapeLayer layer];
        arc.path =path.CGPath;
        gradientLayer.mask=arc;
    });
}



@end
