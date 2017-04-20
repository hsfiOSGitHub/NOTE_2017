//
//  SZBAlertView3.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "PhotoView.h"

@implementation PhotoView
//初  始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (PhotoView *)[self loadNibView];
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
    //配置self
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    //配置取消按钮
    [_cancelBtn setBackgroundColor:KRGB(20, 157, 192, 1)];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
