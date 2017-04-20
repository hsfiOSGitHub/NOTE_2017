//
//  NetErrorView.m
//  SZB_doctor
//
//  Created by monkey2016 on 16/10/13.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "NetErrorView.h"

@implementation NetErrorView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (NetErrorView *)[self loadNibView];
        self.frame = frame;
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
    _loadAgainBtn.layer.masksToBounds = YES;
    _loadAgainBtn.layer.cornerRadius = 10;
}
//绘制
- (void)drawRect:(CGRect)rect {
    [self setUpSubviews];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUpSubviews];
}
//关闭
- (void)closeBtnAction:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgViewLeftConstraints.constant = KScreenWidth;
        [self.bgView setNeedsLayout];
    } completion:^(BOOL finished) {
        [self.bgView removeFromSuperview];
        [self removeFromSuperview];
    }];
}









@end
