//
//  ViewController.m
//  WJKeyBoard
//
//  Created by wujing on 16/5/26.
//  Copyright © 2016年 wujing. All rights reserved.
//

#import "ViewController.h"
#import "IQKeyboardManager.h"
#import "IQKeyboardReturnKeyHandler.h"
@interface ViewController ()
{
    IQKeyboardReturnKeyHandler *returnKeyHandler;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.number.keyboardType=UIKeyboardTypeNumberPad;
#pragma mark ---2.在键盘上会自动添加一个工具条，工具条上有左箭头和右箭头用来切换的输入文本框，还有完成按钮用来收回键盘。如不需要，可如下设置
//    [IQKeyboardManager sharedManager].enableAutoToolbar=NO;
#pragma mark --- 3.可以将键盘上的return按键，变为Next/Done按键，默认最后一个UITextField/UITextView的键盘return键变为Done。顺序是按照创建控件的先后顺序，而不是从上到下的摆放顺序。设置如下：
//    returnKeyHandler = [[IQKeyboardReturnKeyHandler alloc] initWithViewController:self];
//    returnKeyHandler.lastTextFieldReturnKeyType = UIReturnKeyEmergencyCall;
#pragma mark --- 4.设置点击背景收回键盘。也可用下面注释掉的touchesEnded方法实现，看个人喜好。
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
#pragma mark --- 5.如果你的视图有导航栏，你不想上移View时,UINavigationBar消失,你也可以进行相应设置：如果你使用的是storyboard or xib，只需将当前视图视图控制器中的UIView class变为UIScrollView。[注意：我本人用这种方法没有实现，于是我在self.view上放了个scrollView，在scrollView上再放控件就可以了，有兴趣的可以试一下直接将当前视图视图控制器中的UIView class变为UIScrollView]。当然如果你用的是代码，你就需要覆盖UIViewController中的'-(void)loadView' 方法：【我这里用的是storyboard，有兴趣的可以试一下代码】
//    -(void)loadView {
//        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];     self.view = scrollView;
//    }
}

//- (void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
