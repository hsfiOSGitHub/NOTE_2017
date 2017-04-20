//
//  NetworkLoadFailureView.m
//  yuntangyi
//
//  Created by yuntangyi on 16/10/10.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "NetworkLoadFailureView.h"

@implementation NetworkLoadFailureView
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (NetworkLoadFailureView *)[self loadNibView];
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
    self.loadAgainBtn.layer.masksToBounds = YES;
    self.loadAgainBtn.layer.cornerRadius = 10;
    self.loadAgainBtn.layer.borderColor = [KRGB(0, 172, 204, 1) CGColor];
    self.loadAgainBtn.layer.borderWidth = 1;
}
//绘制
- (void)drawRect:(CGRect)rect {
    [self setUpSubviews];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUpSubviews];
}
- (IBAction)noAction:(UIButton *)sender {
    NSLog(@"点我干嘛，滚蛋！");
}


@end
