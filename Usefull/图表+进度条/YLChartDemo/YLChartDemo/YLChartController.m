//
//  YLChartController.m
//  YLChartDemo
//
//  Created by LELE on 17/4/12.
//  Copyright © 2017年 rect. All rights reserved.
//
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#import "YLChartController.h"
#import "YLChartHeader.h"   
@interface YLChartController ()

@end

@implementation YLChartController

- (void)viewDidLoad {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = self.title;
    [super viewDidLoad];
    switch (self.index) {
        case 0:
            [self drawArc];
            break;
        case 1:
            [self drawCyclicSsequence];
            break;
        case 2:
            [self drawCyclicWhile];
            break;
        case 3:
            [self drawGradientColorArc];
            break;
        case 4:
            [self drawLineChart];
            break;
        case 5:
            [self drawRotateArc];
            break;
    }
}

-(void)drawArc
{
    YLArcChart* arcChart = [[YLArcChart alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenWidth) duration:3.0 showBgCyclic:YES];
    [self.view addSubview:arcChart];
}

-(void)drawCyclicSsequence
{
    NSArray* dataValue = @[@0.25,@0.25,@0.5];
    NSArray* colors = @[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor]];
    YLCyclicChart* cyclicChart = [[YLCyclicChart alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenWidth) dataValue:dataValue colors:colors duration:3.0 startAngle:-90 radius:80 lineWidth:3.0 cyclicChartType:YLCyclicChartType_sequence];
    [self.view addSubview:cyclicChart];
}

-(void)drawCyclicWhile
{
    NSArray* dataValue = @[@0.25,@0.25,@0.5];
    NSArray* colors = @[[UIColor redColor],[UIColor yellowColor],[UIColor blueColor]];
    YLCyclicChart* cyclicChart = [[YLCyclicChart alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenWidth) dataValue:dataValue colors:colors duration:3.0 startAngle:-90 radius:80 lineWidth:3.0 cyclicChartType:YLCyclicChartType_while];
    [self.view addSubview:cyclicChart];
}

-(void)drawGradientColorArc
{
    YLGradientArcChart*  gradientArcChart = [[YLGradientArcChart alloc] initWithFrame:CGRectMake(0, 100, kScreenWidth, kScreenWidth)];
    [self.view addSubview:gradientArcChart];
}

-(void)drawLineChart
{
    [self addLineChartFirse];
    [self addLineChartSecond];
}

-(void)addLineChartFirse
{
    NSMutableArray* dataValue = [NSMutableArray array];
    NSArray* colors = @[[UIColor colorWithRed:40.0 / 255.0 green:101.0 / 255.0 blue:132.0 / 255.0 alpha:1.0],[UIColor colorWithRed:40.0 / 255.0 green:101.0 / 255.0 blue:132.0 / 255.0 alpha:0.6],[UIColor colorWithRed:40.0 / 255.0 green:101.0 / 255.0 blue:132.0 / 255.0 alpha:0.3]];
    
    CGPoint point1 = CGPointMake(10, 200 - 10);
    CGPoint point2 = CGPointMake(50, 120);
    CGPoint point3 = CGPointMake(100, 90);
    CGPoint point4 = CGPointMake(150, 40);
    CGPoint point5 = CGPointMake(200, 90);
    CGPoint point6 = CGPointMake(250, 100);
    CGPoint point7 = CGPointMake(280, 80);
    NSValue *value1 = [NSValue valueWithCGPoint:point1];
    NSValue *value2 = [NSValue valueWithCGPoint:point2];
    NSValue *value3 = [NSValue valueWithCGPoint:point3];
    NSValue *value4 = [NSValue valueWithCGPoint:point4];
    NSValue *value5 = [NSValue valueWithCGPoint:point5];
    NSValue *value6 = [NSValue valueWithCGPoint:point6];
    NSValue *value7 = [NSValue valueWithCGPoint:point7];
    
    [dataValue addObject:value1];
    [dataValue addObject:value2];
    [dataValue addObject:value3];
    [dataValue addObject:value4];
    [dataValue addObject:value5];
    [dataValue addObject:value6];
    [dataValue addObject:value7];
    
    
    
    YLLineChart* lineChart = [[YLLineChart alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 200) dataValue:dataValue colors:colors pathCurve:YES];
    lineChart.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineChart];
}

-(void)addLineChartSecond
{
    NSMutableArray* dataValue = [NSMutableArray array];
    NSArray* colors = @[[UIColor colorWithRed:113.0 / 255.0 green:21.0 / 255.0 blue:100.0 / 255.0 alpha:1.0],[UIColor colorWithRed:113.0 / 255.0 green:21.0 / 255.0 blue:100.0 / 255.0 alpha:0.6],[UIColor colorWithRed:113.0 / 255.0 green:21.0 / 255.0 blue:100.0 / 255.0 alpha:0.3]];
    
    CGPoint point1 = CGPointMake(10, 200 - 10);
    CGPoint point2 = CGPointMake(40, 120);
    CGPoint point3 = CGPointMake(80, 100);
    CGPoint point4 = CGPointMake(120, 30);
    CGPoint point5 = CGPointMake(160, 120);
    CGPoint point6 = CGPointMake(200, 100);
    CGPoint point7 = CGPointMake(240, 70);
    CGPoint point8 = CGPointMake(270, 80);
    CGPoint point9 = CGPointMake(290, 100);
    NSValue *value1 = [NSValue valueWithCGPoint:point1];
    NSValue *value2 = [NSValue valueWithCGPoint:point2];
    NSValue *value3 = [NSValue valueWithCGPoint:point3];
    NSValue *value4 = [NSValue valueWithCGPoint:point4];
    NSValue *value5 = [NSValue valueWithCGPoint:point5];
    NSValue *value6 = [NSValue valueWithCGPoint:point6];
    NSValue *value7 = [NSValue valueWithCGPoint:point7];
    NSValue *value8 = [NSValue valueWithCGPoint:point8];
    NSValue *value9 = [NSValue valueWithCGPoint:point9];
    
    [dataValue addObject:value1];
    [dataValue addObject:value2];
    [dataValue addObject:value3];
    [dataValue addObject:value4];
    [dataValue addObject:value5];
    [dataValue addObject:value6];
    [dataValue addObject:value7];
    [dataValue addObject:value8];
    [dataValue addObject:value9];
    
    
    
    YLLineChart* lineChart = [[YLLineChart alloc] initWithFrame:CGRectMake(0, 320, kScreenWidth, 200) dataValue:dataValue colors:colors pathCurve:NO];
    lineChart.backgroundColor = [UIColor blackColor];
    [self.view addSubview:lineChart];

}

-(void)drawRotateArc
{
    NSArray* colors = @[[UIColor redColor],[UIColor blueColor],[UIColor yellowColor],[UIColor greenColor]];
    YLRotateCyclic* rotateCyclic = [[YLRotateCyclic alloc] initWithFrame:CGRectMake(0, 0, 80, 80) colors:colors drawDuration:3.0 sapceAngle:20.0];
    rotateCyclic.center = self.view.center;
    [self.view addSubview:rotateCyclic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
