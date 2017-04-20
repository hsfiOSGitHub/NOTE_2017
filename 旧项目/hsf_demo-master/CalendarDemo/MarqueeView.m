//
//  MarqueeView.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/20.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "MarqueeView.h"

@implementation MarqueeView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.bgColor = [UIColor whiteColor];
        self.fontColor = [UIColor blackColor];
        self.fontSize = 17;
    }
    return self;
}

-(void)setTitle:(NSString *)title{
    _title = title;
    
    //创建跑马灯
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
        obj = nil;
    }];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:self.fontSize];
    CGSize size =  [title boundingRectWithSize:CGSizeMake( MAXFLOAT,self.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
    CGFloat width = size.width;
    if (width > self.width) {
        SXMarquee *marquee = [[SXMarquee alloc]initWithFrame:self.bounds speed:4 Msg:title bgColor:self.bgColor txtColor:self.fontColor];
        [marquee changeMarqueeLabelFont:[UIFont boldSystemFontOfSize:self.fontSize]];
        [self addSubview:marquee];
        [marquee start];
    }else{
        UILabel *label = [[UILabel alloc]initWithFrame:self.bounds];
        label.text = title;
        label.textColor = self.fontColor;
        label.backgroundColor = self.bgColor;
        label.font = [UIFont systemFontOfSize:self.fontSize];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
    }
}

@end
