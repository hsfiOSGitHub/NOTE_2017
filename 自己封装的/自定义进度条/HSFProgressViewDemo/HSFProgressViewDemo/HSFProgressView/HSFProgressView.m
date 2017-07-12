//
//  HSFProgressView.m
//  HSFProgressViewDemo
//
//  Created by JuZhenBaoiMac on 2017/7/12.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFProgressView.h"

@interface HSFProgressView ()

@property (nonatomic,strong) NSMutableArray *viewsArr;

@end

@implementation HSFProgressView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
//重写frame
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
}
//配置
-(void)setUp{
    self.progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.progressViewHeight)];
    CGAffineTransform transform = CGAffineTransformMakeScale(1.0, self.progressViewHeight/2.0);
    self.progressView.transform = transform;
    self.progressView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    [self.progressView setProgressTintColor:self.minColor];
    [self.progressView setTrackTintColor:self.maxColor];
    self.progressView.progress = self.progress;
    [self addSubview:self.progressView];
}
//添加view
-(void)addView:(UIView *)view atProgress:(CGFloat)progress{
    view.center = CGPointMake(self.progressView.frame.size.width * progress, self.progressView.center.y);
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = view.frame.size.height/2;
    [self addSubview:view];
    [self.viewsArr addObject:view];
}
//设置progress
-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    self.progressView.progress = progress;
    if (self.viewsArr.count > 0) {
        __block CGFloat min_x = self.progressView.frame.size.width * progress;
        [self.viewsArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIView *view = (UIView *)obj;
            view.backgroundColor = self.maxColor;
            CGFloat x = view.frame.origin.x;
            //将原来的layer移除
            if (view.layer.sublayers.count > 0) {
                [view.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj removeFromSuperlayer];
                }];
            }
            //添加新的layer
            if (min_x > x) {
                CGFloat deta = min_x - x;
                CALayer *layer = [[CALayer alloc]init];
                layer.frame = CGRectMake(0, 0, deta, view.frame.size.height);
                layer.backgroundColor = self.minColor.CGColor;
                [view.layer addSublayer:layer];
            }
        }];
    }
}
//圆角
-(void)setCorner{
    self.progressView.layer.masksToBounds = YES;
    self.progressView.layer.cornerRadius = self.progressViewHeight/2;
}

#pragma mark -懒加载
-(NSMutableArray *)viewsArr{
    if (!_viewsArr) {
        _viewsArr = [NSMutableArray array];
    }
    return _viewsArr;
}

@end
