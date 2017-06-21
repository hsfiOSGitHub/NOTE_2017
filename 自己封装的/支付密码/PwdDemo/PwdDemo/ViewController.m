//
//  ViewController.m
//  PwdDemo
//
//  Created by JuZhenBaoiMac on 2017/6/20.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "ViewController.h"

#import "HSFKeyboard.h"
#import "HSFPwdView.h"


@interface ViewController ()<HSFKeyboardDelegate, HSFPwdViewDelegate>

@property (nonatomic,strong) HSFPwdView *pwdView;
@property (nonatomic,strong) HSFKeyboard *keyboard;
@property (nonatomic,strong) UIView *bgView;

@end

@implementation ViewController
#pragma mark -懒加载
-(UIView *)bgView{
    if (!_bgView) {
        //密码
        self.pwdView = [HSFPwdView pwdViewWithFrame:CGRectMake(20, 20, [UIScreen mainScreen].bounds.size.width - 40, 50) delegate:self pwdNumber:6 pwdType:PwdType_Star showType:ShowType_Padding];
        [self.pwdView setBorderColor:[UIColor lightGrayColor] borderWidth:1 cornerRadius:10];
        
        //键盘
        self.keyboard = [HSFKeyboard keyboardWithFrame:CGRectMake(0, 90, 0, 0) delegate:self keyboardType:HSFKeyboardType_Decimal];
        
        //bgView
        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.keyboard.frame.size.width, self.keyboard.frame.size.height + self.pwdView.frame.size.height + 40)];
//        _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - self.keyboard.frame.size.height - self.pwdView.frame.size.height - 40, self.keyboard.frame.size.width, self.keyboard.frame.size.height + self.pwdView.frame.size.height)];
        _bgView.backgroundColor = [UIColor whiteColor];
        
        [_bgView addSubview:self.pwdView];
        [_bgView addSubview:self.keyboard];
    }
    return _bgView;
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.bgView];
    
}

//show
- (IBAction)show:(id)sender {
    [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.frame = CGRectMake(0, self.view.frame.size.height - self.keyboard.frame.size.height - self.pwdView.frame.size.height - 40, self.keyboard.frame.size.width, self.keyboard.frame.size.height + self.pwdView.frame.size.height + 40);
    } completion:^(BOOL finished) {
        
    }];
}
//dismiss
- (IBAction)dismiss:(id)sender {
    [UIView animateWithDuration:0.2 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.bgView.frame = CGRectMake(0, self.view.frame.size.height, self.keyboard.frame.size.width, self.keyboard.frame.size.height + self.pwdView.frame.size.height + 40);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark -显示/隐藏  密码
- (IBAction)showPwd:(id)sender {
    [self.pwdView showPwd];
}
- (IBAction)hidePwd:(id)sender {
    [self.pwdView hidePwd];
}


#pragma mark -HSFKeyboardDelegate
//点击键盘
-(void)keyboardACTIONWith:(NSString *)str atIndex:(NSInteger)index{
    [self.pwdView addPwd:str];
}

#pragma mark -HSFPwdViewDelegate
//填写密码完整
-(void)inputePwdSuccess:(NSString *)pwd{
    NSLog(@"%@: === inputePwdSuccess ===",NSStringFromClass([self class]));
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
