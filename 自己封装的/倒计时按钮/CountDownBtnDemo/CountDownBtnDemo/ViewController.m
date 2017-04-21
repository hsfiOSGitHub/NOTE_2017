//
//  ViewController.m
//  CountDownBtnDemo
//
//  Created by JuZhenBaoiMac on 2017/4/21.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "ViewController.h"

#import "CountDownButton.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CountDownButton *btn = [CountDownButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 150, 50);
    //配置倒计时按钮
    /**可选 -> 自定义
     btn.count = 10;//默认：60秒
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
     */
    
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
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
