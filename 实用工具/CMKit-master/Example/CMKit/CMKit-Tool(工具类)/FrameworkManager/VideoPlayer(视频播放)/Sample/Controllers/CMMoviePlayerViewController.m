//
//  CMMoviePlayerViewController.m
//  CMKit
//
//  Created by HC on 17/2/14.
//  Copyright © 2017年 UTOUU. All rights reserved.
//

#import "CMMoviePlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ZFPlayer.h"
#import "CMMoviePlayerNextViewController.h"
//#import "UINavigationController+FDFullscreenPopGesture.h"

@interface CMMoviePlayerViewController ()<ZFPlayerDelegate>
/** 播放器View的父视图*/
@property (weak, nonatomic)  IBOutlet UIView *playerFatherView;
@property (strong, nonatomic) ZFPlayerView *playerView;
/** 离开页面时候是否在播放 */
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation CMMoviePlayerViewController

#pragma mark - 生命周期
- (void)dealloc
{
    NSLog(@"%@释放了",self.class);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    // pop回来时候是否自动播放
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        [self.playerView play];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        [self.playerView pause];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
}

#pragma mark - 初始化UI
- (void)initUI {
    /*
     self.playerFatherView = [[UIView alloc] init];
     [self.view addSubview:self.playerFatherView];
     [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
     make.top.mas_equalTo(20);
     make.leading.trailing.mas_equalTo(0);
     // 这里宽高比16：9,可自定义宽高比
     make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
     }];
     */
    self.playerView = [[ZFPlayerView alloc] init];
    
    /*****************************************************************************************
     *   // 指定控制层(可自定义)
     *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
     *   // 设置控制层和播放模型
     *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
     ******************************************************************************************/
    [self.playerView playerControlView:nil playerModel:self.playerModel];
    
    // 设置代理
    self.playerView.delegate = self;
    
    //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
    // self.playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
    
    // 打开下载功能（默认没有这个功能）
    self.playerView.hasDownload    = NO;
    // 打开预览图
    self.playerView.hasPreviewView = YES;
    
    // 是否自动播放，默认不自动播放
    [self.playerView autoPlayTheVideo];

}


// 返回值要必须为NO
- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - ZFPlayerDelegate
- (void)zf_playerBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)zf_playerDownload:(NSString *)url
//{
//    // 此处是截取的下载地址，可以自己根据服务器的视频名称来赋值
//    NSString *name = [url lastPathComponent];
//    [[ZFDownloadManager sharedDownloadManager] downFileUrl:url filename:name fileimage:nil];
//    // 设置最多同时下载个数（默认是3）
//    [ZFDownloadManager sharedDownloadManager].maxCount = 4;
//}

#pragma mark - Getter

- (ZFPlayerModel *)playerModel
{
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        _playerModel.title            = @"这里设置视频标题";
        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
        
    }
    return _playerModel;
}

#pragma mark - Action

- (IBAction)playNewVideo:(UIButton *)sender {
    self.playerModel.title            = @"这是新播放的视频";
    self.playerModel.videoURL         = [NSURL URLWithString:@"http://baobab.wdjcdn.com/1456665467509qingshu.mp4"];
    // 设置网络封面图
    self.playerModel.placeholderImageURLString = @"http://img.wdjimg.com/image/video/447f973848167ee5e44b67c8d4df9839_0_0.jpeg";
    // 从xx秒开始播放视频
    // self.playerModel.seekTime         = 15;
    [self.playerView resetToPlayNewVideo:self.playerModel];
}

- (IBAction)nextController:(UIButton *)sender {
    CMMoviePlayerNextViewController *vc2 = [[CMMoviePlayerNextViewController alloc] init];
    [self.navigationController pushViewController:vc2 animated:YES];

}

@end
