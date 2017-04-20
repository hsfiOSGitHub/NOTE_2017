//
//  SZBAlertView2.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SexView.h"

@interface SexView ()

@end

@implementation SexView
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
       
        self = (SexView *)[self loadNibView];
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
    //注册通知
}
//绘制
- (void)drawRect:(CGRect)rect {
    [self setUpSubviews];
}
-(void)awakeFromNib{
    [self setUpSubviews];
}
//男
- (IBAction)man:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sex" object:nil userInfo:@{@"gender":@"0"}];
}
//女
- (IBAction)woman:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sex" object:nil userInfo:@{@"gender":@"1"}];
}

@end
