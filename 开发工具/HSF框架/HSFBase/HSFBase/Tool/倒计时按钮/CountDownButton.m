//
//  CountDownButton.m
//  CountDownButton
//
//  Created by liquan on 2017/4/17.
//  Copyright © 2017年 liquan. All rights reserved.
//

#import "CountDownButton.h"

//默认的倒计时60s
static const NSInteger DefaultCount = 60;
#define  DefaultTitleFont       [UIFont systemFontOfSize:14]  //默认字体大小：14
#define  DefaultTitle           @"获取验证码"                   //默认标题：获取验证码
#define  DefaultBgColor         [UIColor whiteColor]          //默认背景颜色：白色
#define  DefaultTitleColor      [UIColor orangeColor]         //默认字体颜色：橙色
#define  DefaultBgColor         [UIColor whiteColor]          //默认背景颜色：白色
#define  DefaultBonderColor     [UIColor orangeColor]         //默认边框颜色：橙色
#define  CountDownTitle         @"%02ld 秒"                   //默认标题：获取验证码
#define  CountDownTitleColor    [UIColor whiteColor]          //倒计时字体颜色：白色
#define  CountDownBgColor       [UIColor lightGrayColor]      //倒计时背景颜色：浅灰色
#define  CountDownBonderColor   [UIColor darkGrayColor]       //倒计时边框颜色：深灰色
#define  FinishedTitle          @"重新获取"                     //倒计时边框颜色：深灰色

@interface CountDownButton()
//剩余的时间
@property(nonatomic,assign)NSInteger remainCount;
//计时器
@property(nonatomic,strong)NSTimer *timer;
@end


@implementation CountDownButton
//配置默认时的按钮样式
-(void)setUpBtn_normal{
    if (self.fontSize) {
        self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
    }else{
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    if (self.titleColor_normal) {
        [self setTitleColor:self.titleColor_normal forState:UIControlStateNormal];
    }else{
        [self setTitleColor:DefaultTitleColor forState:UIControlStateNormal];
    }
    if (self.bgColor_normal) {
        [self setBackgroundColor:self.bgColor_normal];
    }else{
        [self setBackgroundColor:DefaultBgColor];
    }
    if (self.bonderColor_normal) {
        self.layer.borderColor = self.bonderColor_normal.CGColor;
    }else{
        self.layer.borderColor = DefaultBonderColor.CGColor;
    }
}
//配置倒计时时的按钮样式
-(void)setUpBtn_countDown{
    if (self.fontSize) {
        self.titleLabel.font = [UIFont systemFontOfSize:self.fontSize];
    }else{
        self.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    if (self.titleColor_countDown) {
        [self setTitleColor:self.titleColor_countDown forState:UIControlStateNormal];
    }else{
        [self setTitleColor:CountDownTitleColor forState:UIControlStateNormal];
    }
    if (self.bgColor_countDown) {
        [self setBackgroundColor:self.bgColor_countDown];
    }else{
        [self setBackgroundColor:CountDownBgColor];
    }
    if (self.bonderColor_countDown) {
        self.layer.borderColor = self.bonderColor_countDown.CGColor;
    }else{
        self.layer.borderColor = CountDownBonderColor.CGColor;
    }
}
#pragma mark -定时器
//设置倒计时 时间
-(void)setCount:(NSInteger)count{
    _count = count;
    _remainCount = count;
}
//定时器循环事件
-(void)timerStart:(NSTimer *)timer{
    if (_remainCount == 0) {
        _remainCount = _count;
        [self stop];
    }else{
        _remainCount --;
        if (self.title_countDown) {
            [self setTitle:[NSString stringWithFormat:self.title_countDown,_remainCount] forState:0];
        }else{
            [self setTitle:[NSString stringWithFormat:CountDownTitle,_remainCount] forState:0];
        }
    }
}

#pragma mark -对外接口
//初始化配置
-(void)setUp{
    if (self.count) {
        _count = self.count;
        _remainCount = self.count;
    }else{
        _count = DefaultCount;
        _remainCount = DefaultCount;
    }
//    [self addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
    //配置默认时的按钮样式
    [self setUpBtn_normal];
    if (self.isAutoCountDown) {
        self.userInteractionEnabled = NO;
        if (self.title_countDown) {
            [self setTitle:[NSString stringWithFormat:self.title_countDown,_count] forState:0];
        }else{
            [self setTitle:[NSString stringWithFormat:CountDownTitle,_count] forState:0];
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    }else{
        self.userInteractionEnabled = YES;
        if (self.title_normal) {
            [self setTitle:self.title_normal forState:0];
        }else{
            [self setTitle:DefaultTitle forState:0];
        }
    }
}

//点击事件（手动点击倒计时按钮）
-(void)start{
    //配置倒计时时的颜色
    [self setUpBtn_countDown];
    self.userInteractionEnabled = NO;
    if (self.title_countDown) {
        [self setTitle:[NSString stringWithFormat:self.title_countDown,_count] forState:0];
    }else{
        [self setTitle:[NSString stringWithFormat:CountDownTitle,_count] forState:0];
    }
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    }
    if (_ClickButtonBlock) {
        self.ClickButtonBlock();
    }
}
//倒计时时间到
-(void)stop{
    //配置默认时的颜色
    [self setUpBtn_normal];
    self.userInteractionEnabled = YES;
    if (_timer) {
        [_timer invalidate]; //停止计时器
        _timer = nil;
        if (self.title_finished) {
            [self setTitle:self.title_finished forState:UIControlStateNormal];
        }else{
            [self setTitle:FinishedTitle forState:UIControlStateNormal];
        }
    }
    if (_CompleteBlock) {
        self.CompleteBlock();
    }
}
//销毁计时器
-(void)dealloc{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
@end
