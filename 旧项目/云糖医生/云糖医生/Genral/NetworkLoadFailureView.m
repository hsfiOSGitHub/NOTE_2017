//
//  NetworkLoadFailureView.m
//  SZB_doctor
//
//  Created by chaoyang on 16/10/10.
//  Copyright © 2016年 monkey2016. All rights reserved.
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
