//
//  YLCyclicChart.m
//  DrawTest
//
//  Created by LELE on 17/4/11.
//  Copyright © 2017年 rect. All rights reserved.
//

#import "YLCyclicChart.h"
@interface YLCyclicChart()
/**
 *  the animation duration
 */
@property(nonatomic,assign)CGFloat dutation;
/**
 *  the radious
 */
@property(nonatomic,assign)CGFloat radius;

/**
 *  start angle
 */
@property(nonatomic,assign)CGFloat startAngle;
@property(nonatomic,assign)CGFloat lineWidth;

/**
 *  the region color
 */
@property(nonatomic,strong)NSArray<UIColor*>* colors;
@property(nonatomic,assign)YLCyclicChartType cyclicChartType;
/**
 *  the dataSource
 */
@property(nonatomic,strong)NSArray<NSNumber*>* dataValue;


@end
@implementation YLCyclicChart

-(instancetype)initWithFrame:(CGRect)frame dataValue:(NSArray *)dataValue colors:(NSArray *)colors duration:(CGFloat)duration startAngle:(CGFloat)startAngle radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth cyclicChartType:(YLCyclicChartType)type
{
    if (self == [super initWithFrame:frame]) {
        self.dataValue = dataValue;
        self.colors = colors;
        self.dutation = duration;
        self.startAngle = startAngle / 360 * M_PI * 2;
        self.cyclicChartType = type;
        self.radius = radius;
        self.lineWidth = lineWidth;
        [self drwaRing];
    }
    return self;
}

-(instancetype)init
{
    if (self == [super init]) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [self setUpDefault];
    }
    return self;
}

-(void)setUpDefault
{
    self.cyclicChartType = YLCyclicChartType_sequence;
    self.dutation = 2.0;
    self.startAngle = -90 / 360 * M_PI * 2 ;
    self.colors = @[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor]];
    self.radius = 50;
    self.lineWidth = 5;
}

-(void)drwaRing
{
    CGPoint center = CGPointMake(self.frame.size.width * 0.5, self.frame.size.height * 0.5);
    
    dispatch_queue_t queue = dispatch_queue_create("my_queue", DISPATCH_QUEUE_CONCURRENT);
    CGFloat startAngle = self.startAngle;
    CGFloat angle = 0;
    CGFloat endAngle = self.startAngle;
    
    NSMutableArray* durations = [NSMutableArray array];
    for (NSNumber* num in self.dataValue) {
        CGFloat scal = num.floatValue * self.dutation;
        NSNumber* durationNum = [NSNumber numberWithFloat:scal];
        [durations addObject:durationNum];
    }
    
    for (int i = 0; i < self.dataValue.count; i++ ) {
        startAngle = endAngle;
        NSNumber* num = self.dataValue[i];
        angle = num.floatValue * M_PI * 2;
        endAngle = startAngle + angle;
        
        NSNumber* durationNum = durations[i];
        CGFloat duratin = durationNum.floatValue;
        dispatch_async(queue, ^{
            if(self.cyclicChartType == YLCyclicChartType_while){
            }else{
                if (i > 0) {
                    [NSThread sleepForTimeInterval:duratin];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                UIBezierPath* path = [UIBezierPath bezierPathWithArcCenter:center radius:self.radius startAngle:startAngle endAngle:endAngle clockwise:YES];
                CAShapeLayer* shapelayer = [CAShapeLayer layer];
                shapelayer.fillColor = [UIColor clearColor].CGColor;
                shapelayer.path = path.CGPath;
                shapelayer.lineWidth = self.lineWidth;
                UIColor* color;
                if (i > self.colors.count - 1) {
                    color = self.colors.lastObject;
                }else{
                    color = self.colors[i];
                }
                shapelayer.strokeColor = color.CGColor;
                [self.layer addSublayer:shapelayer];
                
                CABasicAnimation *ani = [ CABasicAnimation animationWithKeyPath : NSStringFromSelector ( @selector (strokeEnd))];
                ani.fromValue = @0;
                ani.toValue = @1;
                if (self.cyclicChartType == YLCyclicChartType_while) {
                    ani.duration = 1.0;
                }else{
                    ani.duration = duratin;
                }
                [shapelayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
                [self.layer addSublayer: shapelayer];
            });
        });
    }
}


@end
