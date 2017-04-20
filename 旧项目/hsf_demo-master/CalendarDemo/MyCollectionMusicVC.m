//
//  MyCollectionMusicVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "MyCollectionMusicVC.h"


@interface MyCollectionMusicVC ()

@property (nonatomic,strong) LittlePlayerView *littlePlayer_View;

@end

@implementation MyCollectionMusicVC

#pragma mark -懒加载


#pragma mark -配置导航栏
-(void)setUpNavi{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //退出
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"back_common"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
}
//退出
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = KRGB(23, 159, 155, 1.0);
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"我喜欢";
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //配置导航栏
    [self setUpNavi];
    //创建播放小空间
    [self createLittlePlayerView];
}

#pragma mark -创建播放小空间
-(void)createLittlePlayerView{
    self.littlePlayer_View = [[LittlePlayerView alloc]initWithFrame:CGRectMake(0, 50, 50, 50)];
    self.littlePlayer_View.sourceVC = self.sourceVC;
    [self.view addSubview:self.littlePlayer_View];
}

#pragma mark -didReceiveMemoryWarning
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
