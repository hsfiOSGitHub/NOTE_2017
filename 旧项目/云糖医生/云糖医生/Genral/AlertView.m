//
//  AlertView.m
//  SZB_doctor
//
//  Created by monkey2016 on 16/9/7.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //配置self
        [self setUpSelf];
        //添加子控件
        [self addSubViewsForSelf];
    }
    return self;
}
//配置self
-(void)setUpSelf{
    self.backgroundColor = [UIColor lightGrayColor];
    self.alpha = 0;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 10;
}
//添加子控件
-(void)addSubViewsForSelf{
    _alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 100)];
    _alertLabel.numberOfLines = 0;
    _alertLabel.center = self.center;
    _alertLabel.backgroundColor = [UIColor clearColor];
    _alertLabel.textAlignment = NSTextAlignmentCenter;
    _alertLabel.textColor = [UIColor whiteColor];
    _alertLabel.font = [UIFont systemFontOfSize:20];
    [self addSubview:_alertLabel];
}
//展示方法
-(void)showAlertViewForTime:(NSTimeInterval)during{
    self.alpha = 1;
    [UIView animateWithDuration:during animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        
    }];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //配置self
    [self setUpSelf];
    //添加子控件
    [self addSubViewsForSelf];
}


@end
