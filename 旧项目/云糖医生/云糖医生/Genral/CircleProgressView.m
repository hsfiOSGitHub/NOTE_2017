//
//  CircleProgressView.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "CircleProgressView.h"

@implementation CircleProgressView
//初始化方法
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _percent = 0;
        _width = 0;
    }
    return self;
}
//绘制
- (void)drawRect:(CGRect)rect {
    [self addArcBackColor];
    [self drawArc];
    [self addCenterBack];
    [self addCenterLabel];
}
- (void)setPercent:(float)percent{
    _percent = percent;
    [self setNeedsDisplay];
}
- (void)setTitle:(NSString *)title{
    //配置title属性
    UIColor *color = (_titleColor == nil) ? [UIColor orangeColor] : _titleColor;
    CGFloat size = (_fontSize == 0) ? 15 : _fontSize;
    CGSize viewSize = self.bounds.size;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:size],NSFontAttributeName,color,NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,paragraph,NSParagraphStyleAttributeName,nil];
    //绘制文字到区域
    [_title drawInRect:CGRectMake(5, (viewSize.height-_fontSize)/2, viewSize.width-10, _fontSize)withAttributes:attributes];
}
//最底层圆
- (void)addArcBackColor{
    CGColorRef color = (_arcBackColor == nil) ? [UIColor lightGrayColor].CGColor : _arcBackColor.CGColor;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    
    // Draw the slices.
    CGFloat radius = viewSize.width / 2;
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}
//已经完成圆弧
- (void)drawArc{
    if (_percent == 0 || _percent > 1) {
        return;
    }
    if (_percent == 1) {// =100%
        CGColorRef color = (_arcFinishColor == nil) ? [UIColor greenColor].CGColor : _arcFinishColor.CGColor;
        
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        // Draw the slices.
        CGFloat radius = viewSize.width / 2;
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);
        CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
        CGContextSetFillColorWithColor(contextRef, color);
        CGContextFillPath(contextRef);
    }else{// <100%
        float endAngle = 2*M_PI*_percent;//已完成弧度
        
        CGColorRef color = (_arcUnfinishColor == nil) ? [UIColor blueColor].CGColor : _arcUnfinishColor.CGColor;
        CGContextRef contextRef = UIGraphicsGetCurrentContext();
        CGSize viewSize = self.bounds.size;
        CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
        // Draw the slices.
        CGFloat radius = viewSize.width / 2;
        CGContextBeginPath(contextRef);
        CGContextMoveToPoint(contextRef, center.x, center.y);
        CGContextAddArc(contextRef, center.x, center.y, radius,0,endAngle, 0);
        CGContextSetFillColorWithColor(contextRef, color);
        CGContextFillPath(contextRef);
    }
}
//中间小圆
-(void)addCenterBack{
    float width = (_width == 0) ? 5 : _width;
    
    CGColorRef color = (_centerColor == nil) ? [UIColor whiteColor].CGColor : _centerColor.CGColor;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGSize viewSize = self.bounds.size;
    CGPoint center = CGPointMake(viewSize.width / 2, viewSize.height / 2);
    // Draw the slices.
    CGFloat radius = viewSize.width / 2 - width;
    CGContextBeginPath(contextRef);
    CGContextMoveToPoint(contextRef, center.x, center.y);
    CGContextAddArc(contextRef, center.x, center.y, radius,0,2*M_PI, 0);
    CGContextSetFillColorWithColor(contextRef, color);
    CGContextFillPath(contextRef);
}
//中间label
- (void)addCenterLabel{
    //配置title属性
    UIColor *color = (_titleColor == nil) ? [UIColor orangeColor] : _titleColor;
    CGFloat size = (_fontSize == 0) ? 15 : _fontSize;
    CGSize viewSize = self.bounds.size;
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:size],NSFontAttributeName,color,NSForegroundColorAttributeName,[UIColor clearColor],NSBackgroundColorAttributeName,paragraph,NSParagraphStyleAttributeName,nil];
    //绘制文字到区域
    [_title drawInRect:CGRectMake(5, (viewSize.height-_fontSize)/2, viewSize.width-10, _fontSize)withAttributes:attributes];
}


@end
