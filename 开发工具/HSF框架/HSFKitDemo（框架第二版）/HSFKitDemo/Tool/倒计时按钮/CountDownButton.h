//
//  CountDownButton.h
//  CountDownButton
//
//  Created by liquan on 2017/4/17.
//  Copyright © 2017年 liquan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownButton : UIButton

//设置开始倒计时的时间 默认是60s
@property(nonatomic,assign)NSInteger count;
//点击按钮
@property(nonatomic,copy)void(^ClickButtonBlock)();
//倒计时完成后的回调
@property(nonatomic,copy)void(^CompleteBlock)();
//标题
@property (nonatomic,strong) NSString *title_normal;
@property (nonatomic,strong) NSString *title_countDown;
@property (nonatomic,strong) NSString *title_finished;
//字体大小
@property (nonatomic,assign) NSInteger fontSize;
//背景色
@property (nonatomic,strong) UIColor *bgColor_normal;
@property (nonatomic,strong) UIColor *bgColor_countDown;
//标题颜色
@property (nonatomic,strong) UIColor *titleColor_normal;
@property (nonatomic,strong) UIColor *titleColor_countDown;
//边框颜色
@property (nonatomic,strong) UIColor *bonderColor_normal;
@property (nonatomic,strong) UIColor *bonderColor_countDown;
//是否自动倒计时
@property (nonatomic,assign) BOOL isAutoCountDown;


//初始化配置
-(void)setUp;

//点击事件（手动点击倒计时按钮）
-(void)start;
//倒计时时间到
-(void)stop;

//销毁计时器
-(void)dealloc;


/**
 //配置倒计时按钮
 //可选 -> 自定义
 btn.count = 10;默认：60秒
 btn.title_normal = @"点击获取验证码"; //默认标题：获取验证码
 btn.title_countDown = @"%02ld秒后重试";//默认倒计时标题格式：%02ld 秒
 btn.title_finished = @"try again";//默认完成标题：重新获取
 btn.fontSize = 20;//默认字体大小：14
 btn.titleColor_normal = [UIColor blueColor];//默认字体颜色：橙色
 btn.titleColor_countDown = [UIColor redColor];//倒计时字体颜色：白色
 btn.bgColor_normal = [UIColor yellowColor];//默认背景颜色：白色
 btn.bgColor_countDown = [UIColor greenColor];//倒计时背景颜色：浅灰色
 
 //如果需要圆角 先设置
 btn.layer.masksToBounds = YES;
 btn.layer.borderWidth = 1;
 btn.layer.cornerRadius = 10;
 btn.bonderColor_normal = [UIColor redColor];//默认边框颜色：橙色
 btn.bonderColor_countDown = [UIColor orangeColor];//倒计时边框颜色：深灰色


//必须setUp
[btn setUp];
[self.view addSubview:btn];
//点击事件
[btn setClickButtonBlock:^{
    NSLog(@"开始倒计时");
}];
//倒计时完成
[btn setCompleteBlock:^{
    NSLog(@"完成倒计时");
}];

 */



@end
