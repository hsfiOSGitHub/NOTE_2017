//
//  JK_Class2VC.m
//  友照
//
//  Created by monkey2016 on 16/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "JK_Class2VC.h"
#import "ZX_Web_ViewController.h"

@interface JK_Class2VC ()
@property(nonatomic, copy) NSString *htmlStr;
@property(nonatomic, copy) NSString *titleStr;
@end

@implementation JK_Class2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

//考前准备
- (IBAction)kaoQianZhunBei:(id)sender
{
    _titleStr = @"科目二考前准备";
    _htmlStr = @"skill2/keerkaoqianzhunbei";
    [self turnToWeb];
}

//包过秘籍
- (IBAction)baoGuoMiJi:(id)sender
{
    _titleStr = @"科二包过秘籍";
    _htmlStr = @"skill2/keerbaoguomiji";
    [self turnToWeb];
}

//合格标准
- (IBAction)heGeBiaoZhun:(id)sender
{
    _titleStr = @"科目二合格标准";
    _htmlStr = @"skill2/keerhegebiaozhun";
    [self turnToWeb];
}

//安全带
- (IBAction)anQuanDai:(id)sender
{
    _titleStr = @"安全带";
    _htmlStr = @"skill2/anquandai";
    [self turnToWeb];
}

//方向盘
- (IBAction)fangXiangPan:(id)sender
{
    _titleStr = @"方向盘";
    _htmlStr = @"skill2/fangxiangpan";
    [self turnToWeb];
}

//点火开关
- (IBAction)dianHuoKaiGuan:(id)sender
{
    _titleStr = @"点火开关";
    _htmlStr = @"skill2/dianhuokaiguan";
    [self turnToWeb];
}

//调整座椅
- (IBAction)tiaoZhengZuoYi:(id)sender
{
    _titleStr = @"调整座椅";
    _htmlStr = @"skill2/zuoyitiaozheng";
    [self turnToWeb];
}

//后视镜
- (IBAction)houShiJing:(id)sender
{
    _titleStr = @"后视镜";
    _htmlStr = @"skill2/houshijing";
    [self turnToWeb];
}

//加速踏板
- (IBAction)jiaSuTaBan:(id)sender
{
    _titleStr = @"加速踏板";
    _htmlStr = @"skill2/jiasutaban";
    [self turnToWeb];
}

//离合器
- (IBAction)liHeQi:(id)sender
{
    _titleStr = @"离合器";
    _htmlStr = @"skill2/liheqi";
    [self turnToWeb];
}

//驻车制动
- (IBAction)zhuCheZhiDong:(id)sender
{
    _titleStr = @"驻车制动";
    _htmlStr = @"skill2/zhuchezhidong";
    [self turnToWeb];
}

//制动踏板
- (IBAction)zhiDongTaBan:(id)sender
{
    _titleStr = @"制动踏板";
    _htmlStr = @"skill2/zhidongtaban";
    [self turnToWeb];
}

//考试技巧
- (IBAction)kaoShiJiQiao:(id)sender
{
    _titleStr = @"科二考试技巧";
    _htmlStr = @"skill2/kaoshijiqiao";
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
