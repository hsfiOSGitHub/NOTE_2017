//
//  DCChangeNickNameViewController.m
//  CDDMall
//
//  Created by apple on 2017/6/19.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCChangeNickNameViewController.h"

// Controllers

// Models

// Views

// Vendors
#import "JKDBModel.h"
// Categories

// Others

@interface DCChangeNickNameViewController ()

/* 改名 */
@property (strong , nonatomic)UITextField *nickField;

@end

@implementation DCChangeNickNameViewController

#pragma mark - LazyLoad


#pragma mark - LifeCyle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpInit];
    
    [self setUpField];

    [self setUpNav];
}

#pragma mark - initialize
- (void)setUpInit
{
    self.title = @"昵称";
    self.view.backgroundColor = DCBGColor;
}

#pragma mark - 更改昵称
- (void)setUpField
{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.frame  = CGRectMake(0, 70, ScreenW, 44);
    [self.view addSubview:bgView];
    
    _nickField = [[UITextField alloc] init];
    _nickField.placeholder = _oldNickName;
    _nickField.backgroundColor = [UIColor clearColor];
    _nickField.font = PFR14Font;
    _nickField.clearButtonMode = UITextFieldViewModeAlways;
    [_nickField becomeFirstResponder];
    
    _nickField.frame  =CGRectMake(DCMargin, 0, ScreenW - 2 * DCMargin, 44);
    [bgView addSubview:_nickField];
    
    UILabel *markLabel = [[UILabel alloc] init];
    markLabel.text = @"请输入20-40个字符";
    markLabel.textColor = [UIColor lightGrayColor];
    markLabel.font = PFR12Font;
    [self.view addSubview:markLabel];
    markLabel.frame = CGRectMake(DCMargin, bgView.dc_bottom + 5, 200, 35);
}

#pragma mark - 导航栏
- (void)setUpNav
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(surebackItemClick)];
}


#pragma mark - 点击事件

#pragma mark - 确定点击
- (void)surebackItemClick
{
    if (_nickField.text.length != 0) { //更改
        DCUserInfo *userInfo = UserInfoData;
        userInfo.nickname = _nickField.text;
        
        [userInfo save];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
