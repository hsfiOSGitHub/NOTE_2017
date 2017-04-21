//
//  ViewController.m
//  UIButtonTimeInterval
//
//  Created by yaoshuai on 2017/1/21.
//  Copyright © 2017年 ys. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+TimeInterval.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] init];
    
    [btn setTitle:@"点我" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    btn.backgroundColor = [UIColor yellowColor];
    
    [btn sizeToFit];
    btn.center = self.view.center;
    
    // 关键属性，设置每隔多少秒按钮可点
    btn.timeInterval = 2;
    
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
    
}

- (void)btnClick:(UIButton*)sender{
    NSLog(@"xxxxxx");
}


@end
