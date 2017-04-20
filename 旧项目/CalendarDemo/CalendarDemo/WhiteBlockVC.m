//
//  WhiteBlockVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/18.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "WhiteBlockVC.h"

@interface WhiteBlockVC ()

@property (nonatomic,strong) NSTimer *timer;//计时器

@end

@implementation WhiteBlockVC

#pragma mark -配置导航栏
-(void)setUpNavi{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //退出
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back4_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
//退出
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(255, 157, 146, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"别踩白块儿";
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //配置计时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    
}
//计时器事件
-(void)timerAction{
    
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
