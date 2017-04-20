//
//  NetStateView.m
//  yuntangyi
//
//  Created by yuntangyi on 16/10/10.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "NetStateView.h"

@implementation NetStateView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (NetStateView *)[self loadNibView];
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
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
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
