//
//  JK_GetLicense.m
//  友照
//
//  Created by monkey2016 on 16/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "JK_GetLicense.h"
#import "ZX_Web_ViewController.h"

@interface JK_GetLicense ()
@property(nonatomic, copy) NSString *htmlStr;
@end

@implementation JK_GetLicense

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

//驾照年审
- (IBAction)jiaZhaoNianShen:(id)sender
{
    _htmlStr = @"驾照年审";
    [self turnToWeb];
}

//驾照换证
- (IBAction)jiaZhaoHuanZheng:(id)sender
{
    _htmlStr = @"驾照换证";
    [self turnToWeb];
}

//驾照遗失
- (IBAction)jiaZhaoYiShi:(id)sender
{
    _htmlStr = @"驾照遗失";
    [self turnToWeb];
}

//驾照挂失
- (IBAction)jiaZhaoGuaShi:(id)sender
{
    _htmlStr = @"驾照挂失";
    [self turnToWeb];
}

//车辆操作
- (IBAction)cheLiangCaoZuo:(id)sender
{
    _htmlStr = @"车辆操作";
    [self turnToWeb];
}

//特殊天气
- (IBAction)teShuTianQi:(id)sender
{
    _htmlStr = @"特殊天气";
    [self turnToWeb];
}

//夜间行驶
- (IBAction)yeJianXingShi:(id)sender
{
    _htmlStr = @"夜间行驶";
    [self turnToWeb];
}

//刹车技巧
- (IBAction)shaCheJiQiao:(id)sender
{
    _htmlStr = @"刹车技巧";
    [self turnToWeb];
}

//事故处理
- (IBAction)shiGuChuLi:(id)sender
{
    _htmlStr = @"事故处理";
    [self turnToWeb];
}

//停车技巧
- (IBAction)tingCheJiQiao:(id)sender
{
    _htmlStr = @"停车技巧";
    [self turnToWeb];
}

//跳转到本地web界面
- (void)turnToWeb
{
    ZX_Web_ViewController *webVC = [[ZX_Web_ViewController alloc]init];
    webVC.titleStr = _htmlStr;
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
