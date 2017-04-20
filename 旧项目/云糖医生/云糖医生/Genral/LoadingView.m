//
//  LoadingView.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/22.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, frame.size.width/3,  frame.size.width/3)];
        _imageV.center = CGPointMake(frame.size.width / 2, frame.size.height / 2  - 30);
        NSMutableArray *imageArr = [NSMutableArray array];
        for (int i = 0; i < 5; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
            [imageArr addObject:image];
        }
        _imageV.animationImages = imageArr;
        [_imageV setAnimationRepeatCount:0];
        [_imageV setAnimationDuration:1.0];
        [_imageV startAnimating];
        [self addSubview:_imageV];
        
        UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0, _imageV.frame.origin.y + _imageV.frame.size.height + 10, frame.size.width, 30)];
        message.text = @"网络加载中";
        message.textAlignment = NSTextAlignmentCenter;
        message.textColor = KRGB(0, 172, 204, 1);
        [self addSubview:message];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.bounds;
        [btn addTarget:self action:@selector(noAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    return self;
}
- (void)noAction:(UIButton *)sender {
    NSLog(@"点我干嘛，滚蛋！");
}

- (void)dismiss
{
    [self removeFromSuperview];
}
@end
