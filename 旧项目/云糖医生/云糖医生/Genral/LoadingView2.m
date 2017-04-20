//
//  LoadingView2.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/27.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "LoadingView2.h"


@implementation LoadingView2

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (LoadingView2 *)[self loadNibView];
        self.frame = frame;
        [self setUpSubviews];
    }
    return self;
}
//获取到xib中的View
-(UIView *)loadNibView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return views.firstObject;
}
//配置
-(void)setUpSubviews{
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 10;
    
}
//绘制
- (void)drawRect:(CGRect)rect {
    [self setUpSubviews];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUpSubviews];
}

@end
