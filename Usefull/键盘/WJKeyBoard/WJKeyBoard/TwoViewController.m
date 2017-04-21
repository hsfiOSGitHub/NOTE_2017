//
//  TwoViewController.m
//  WJKeyBoard
//
//  Created by wujing on 16/5/26.
//  Copyright © 2016年 wujing. All rights reserved.
//

#import "TwoViewController.h"
#import "IQKeyboardManager.h"
@interface TwoViewController ()

@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark --- 1、当键盘遮挡输入文本框的时候，自动上移View，使被遮挡的部分自动处于键盘的上方。如不需要，可设置如下方法
/*//当前控制器的生命周期
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable=NO;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable=YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
*/


@end
