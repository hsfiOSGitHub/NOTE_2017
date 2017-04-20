//
//  GuideVC.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/7.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//
#import "GuideVC.h"

#import "AppDelegate.h"
#import "SZBNetDataManager+adpic.h"
#import "RegisterVC.h"
#import "LoginVC.h"

@interface GuideVC ()<LoginVCDeletage,RegisterVCDelegate>
@property (weak, nonatomic) IBOutlet UIButton *skipBtn;//跳过
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;//登录
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;//注册

@property (nonatomic,strong) MPMoviePlayerController *player;//播放器对象
@end

@implementation GuideVC

//点击登录 / 跳过
- (IBAction)intoAppAction:(UIButton *)sender {
    LoginVC *login_VC = [[LoginVC alloc]init];
    login_VC.sourceModeVC = @"GuideVC";
    login_VC.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:login_VC];
    [self presentViewController:navi animated:YES completion:nil];
}
//点击注册
- (IBAction)registerBtnAction:(UIButton *)sender {
    RegisterVC *register_VC = [[RegisterVC alloc]init];
    register_VC.sourceModeVC = @"GuideVC";
    register_VC.delegate = self;
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:register_VC];
    [self presentViewController:navi animated:YES completion:nil];
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //palyMp4
    [self playMp4];
    // 配置按钮
    _skipBtn.layer.masksToBounds =YES;
    _skipBtn.layer.cornerRadius = 20;
    
    _loginBtn.layer.masksToBounds = YES;
    _loginBtn.layer.cornerRadius = 5;
//    _loginBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
//    _loginBtn.layer.borderWidth = 1;
    
    _registerBtn.layer.masksToBounds = YES;
    _registerBtn.layer.cornerRadius = 5;
//    _registerBtn.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
//    _registerBtn.layer.borderWidth = 1;
    
}
-(void)playMp4{
    //首先创建 视频播放器控件
    _player = [[MPMoviePlayerController alloc]init];
    //获取视频的地址
    NSString * path = [[NSBundle mainBundle] pathForResource:@"guideVideo" ofType:@"mp4"];
    NSURL *movieUrl = [NSURL fileURLWithPath:path];
    self.player=[[MPMoviePlayerController alloc] initWithContentURL:movieUrl];
    [self.player.view setFrame:self.view.frame];//全屏
    self.player.controlStyle =MPMovieControlStyleNone;//没有任何控制控件的模式
    self.player.repeatMode = MPMovieRepeatModeOne;//循环播放
    [self.player prepareToPlay];
    [self.player setShouldAutoplay:YES];
    [self.view addSubview:self.player.view];
    [self.view sendSubviewToBack:self.player.view];
    //给视频控制器添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviewFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:_player];//用来监听视频是否播放完毕
}
#pragma mark -viewDidLoad
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //停止播放
    [self.player stop];
    self.player = nil;
}

-(void)moviewFinish:(NSNotification *)notification {
    //按钮显示
    //播放完毕,把通知对象player移出
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_player];
    //同时 把播放控制器 的 view移出
    [_player.view removeFromSuperview];
}
#pragma mark -LoginVCDeletage RegisterVCDelegate
-(void)quitLoginVCPlayMp4Again{
    [self playMp4];
}
-(void)quitRegisterVCPlayMp4{
    [self playMp4];
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
