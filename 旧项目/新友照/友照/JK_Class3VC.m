//
//  JK_Class3VC.m
//  友照
//
//  Created by monkey2016 on 16/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "JK_Class3VC.h"
#import "ZX_Web_ViewController.h"

@interface JK_Class3VC ()
@property(nonatomic, copy) NSString *htmlStr;
@property(nonatomic, copy) NSString *titleStr;
@end

@implementation JK_Class3VC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

//考前准备
- (IBAction)kaoQianZhunBei:(id)sender
{
    _titleStr = @"科目三考前须知";
    _htmlStr = @"skill2/kesankaoqianzhunbei";
    [self turnToWeb];
}

// 包过秘籍
- (IBAction)baoGuoMiJi:(id)sender
{
    _titleStr = @"科目三保过秘籍";
    _htmlStr = @"skill2/kesanbaoguomiji";
    [self turnToWeb];
}

//合格标准
- (IBAction)heGeBiaoZhun:(id)sender
{
    _titleStr = @"科目三合格标准";
    _htmlStr = @"skill2/kesanhegebiaozhun";
    [self turnToWeb];
}

//灯光
- (IBAction)dengGuang:(id)sender
{
    _titleStr = @"灯光";
    _htmlStr = @"skill2/dengguang";
    [self turnToWeb];
}

//档位操作
- (IBAction)dangWeiCaoZuo:(id)sender
{
    _titleStr = @"档位操作";
    _htmlStr = @"skill2/dangweicaozong";
    [self turnToWeb];
}

//直线行驶
- (IBAction)zhiXianXingShi:(id)sender
{
    _titleStr = @"直线行驶";
    _htmlStr = @"skill2/zhixing";
    [self turnToWeb];
}

//车距标准
- (IBAction)cheJuBiaoZhun:(id)sender
{
    _titleStr = @"车距标准";
    _htmlStr = @"skill2/chejupanduan";
    [self turnToWeb];
}

//考试技巧
- (IBAction)kaoShiJiQiao:(id)sender
{
    _titleStr = @"科三考试技巧";
    _htmlStr = @"skill2/kaoshijiqiaokesan";
    [self turnToWeb];
}

//跳转到本地web界面
- (void)turnToWeb
{
    ZX_Web_ViewController *webVC = [[ZX_Web_ViewController alloc]init];
    webVC.titleStr = _titleStr;
    webVC.htmlStr = _htmlStr;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
