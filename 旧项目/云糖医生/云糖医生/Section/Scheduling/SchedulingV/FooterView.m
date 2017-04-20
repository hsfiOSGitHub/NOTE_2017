//
//  FooterView.m
//  云糖医生
//
//  Created by chaoyang on 16/11/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "FooterView.h"

@implementation FooterView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (FooterView *)[self loadNibView];
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
    self.changeBtn.layer.cornerRadius = 5;
    self.changeBtn.layer.masksToBounds = YES;
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
