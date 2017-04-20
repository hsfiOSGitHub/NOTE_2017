//
//  YLRotateCyclic.m
//  DrawTest
//
//  Created by LELE on 17/4/12.
//  Copyright © 2017年 rect. All rights reserved.
//

#import "YLRotateCyclic.h"
@interface YLRotateCyclic()
/**
 *  the colors
 */
@property(nonatomic,strong)NSArray<UIColor*>* colors;

/**
 *  the layer draw time,Default is 2s
 */
@property(nonatomic,assign)CGFloat drawDuration;
/**
 *  the space angle,eg:90
 */
@property(nonatomic,assign)CGFloat spaceAngle;

@property(nonatomic,strong)NSMutableArray<CALayer*>* layers;
@end
@implementation YLRotateCyclic
-(NSMutableArray<CALayer *> *)layers
{
    if (_layers == nil) {
        _layers = [NSMutableArray array];
    }
    return _layers;
}

-(instancetype)initWithFrame:(CGRect)frame colors:(NSArray *)colors drawDuration:(CGFloat)drawDuration sapceAngle:(CGFloat)spaceAngle
{
    if (self = [super initWithFrame:frame]) {
        self.colors = colors;
        self.drawDuration = drawDuration;
        self.spaceAngle = spaceAngle;
        self.spaceAngle = 15.0;
        [self drawRotateCyclic];
    }
    return self;
}

-(instancetype)init
{
    if (self == [super init]) {
        [self setUpDefault];
        [self drawRotateCyclic];
    }
    return self;
}

-(void)setUpDefault
{
    self.frame = CGRectMake(0, 0, 80, 80);
    self.colors = @[[UIColor redColor],[UIColor blueColor],[UIColor yellowColor],[UIColor greenColor],[UIColor purpleColor]];
    self.drawDuration = 3.0;
    self.spaceAngle = 15.0;
}


-(void)drawRotateCyclic
{
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    CGFloat radious = self.frame.size.width * 0.5 - 5;

    CGFloat startAngle = 0;
    CGFloat angle = 1.0 / self.colors.count * M_PI * 2;
    CGFloat endAngle = 0;
    for (int i = 0; i < self.colors.count; i++) {
        if(i == 0){
            startAngle = endAngle;
        }else{
            startAngle = startAngle + angle;
        }
        endAngle = startAngle + angle - (self.spaceAngle / 360.0) * M_PI * 2;
        UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:center radius:radious startAngle:startAngle endAngle:endAngle clockwise:YES];
        
        CAShapeLayer* shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        UIColor* color = self.colors[i];
        shapeLayer.strokeColor = color.CGColor;
        shapeLayer.lineWidth = 3.0;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        [self.layer addSublayer:shapeLayer];

        CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
        ani.fromValue = @0;
        ani.toValue = @1;
        ani.duration = self.drawDuration;
        [shapeLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
        [self.layers addObject:shapeLayer];
    }
    [self addRotateAnimation];
}

-(void)addRotateAnimation
{
    CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:2*M_PI];
    animation.duration = 2;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = CGFLOAT_MAX;
    [self.layer addAnimation:animation forKey:nil];
}


@end
