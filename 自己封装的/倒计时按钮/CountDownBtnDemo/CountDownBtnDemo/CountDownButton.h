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

@end
