//
//  VideoPlayerViewController.m
//  TYVideoPlayerDemo
//
//  Created by tany on 16/7/11.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "TYVideoPlayerController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoPlayerViewController ()<TYVideoPlayerControllerDelegate>
@property (nonatomic, weak) TYVideoPlayerController *playerController;
@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addVideoPlayerController];
    
    [self loadVodVideo];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    CGRect frame = self.view.frame;
    if (_playerController.isFullScreen) {
        _playerController.view.frame = CGRectMake(0, 0, MAX(CGRectGetHeight(frame), CGRectGetWidth(frame)), MIN(CGRectGetHeight(frame), CGRectGetWidth(frame)));
    }else {
         _playerController.view.frame = CGRectMake(0, 0, MIN(CGRectGetHeight(frame), CGRectGetWidth(frame)), MIN(CGRectGetHeight(frame), CGRectGetWidth(frame))*9/16);
    }
}

- (BOOL)prefersStatusBarHidden
{
    if (!_playerController || !_playerController.isFullScreen) {
        return NO;
    }
    return [_playerController isControlViewHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation )preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (void)addVideoPlayerController
{
    TYVideoPlayerController *playerController = [[TYVideoPlayerController alloc]init];
    //playerController.shouldAutoplayVideo = NO;
    playerController.delegate = self;
    [self addChildViewController:playerController];
    [self.view addSubview:playerController.view];
    _playerController = playerController;
}

- (void)loadVodVideo
{
    // 点播  http://baobab.wdjcdn.com/1442142801331138639111.mp4
    // http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8
    NSURL *streamURL = [NSURL URLWithString:@"http://lxls.jzbwlkj.com/Uploads/Movie/2017-03-24/What if I said.mp4"];
    
    [_playerController loadVideoWithStreamURL:streamURL];
}

- (void)loadLiveVideo
{
    // 直播  http://live.hkstv.hk.lxdns.com/live/hks/playlist.m3u8
    NSURL *streamURL = [NSURL URLWithString:@"http://lxls.jzbwlkj.com/Uploads/Movie/2017-03-24/What if I said.mp4"];
    
    [_playerController loadVideoWithStreamURL:streamURL];
}

- (void)loadLocalVideo
{
    // 本地播放
    NSString* path = [[NSBundle mainBundle] pathForResource:@"test_264" ofType:@"mp4"];
    if (!path) {
        UIAlertView *alerView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"本地文件不存在！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alerView show];
        return;
    }
    NSURL* streamURL = [NSURL fileURLWithPath:path];
    [_playerController loadVideoWithStreamURL:streamURL];
}


#pragma mark - action

- (IBAction)playVodAction:(id)sender {
    [self loadVodVideo];
}

- (IBAction)playLiveAction:(id)sender {
    [self loadLiveVideo];
}

- (IBAction)playLocalAction:(id)sender {
    [self loadLocalVideo];
}

#pragma mark - delegate

- (void)videoPlayerController:(TYVideoPlayerController *)videoPlayerController readyToPlayURL:(NSURL *)streamURL
{
    
}

- (void)videoPlayerController:(TYVideoPlayerController *)videoPlayerController endToPlayURL:(NSURL *)streamURL
{
    
}

- (void)videoPlayerController:(TYVideoPlayerController *)videoPlayerController handleEvent:(TYVideoPlayerControllerEvent)event
{
    switch (event) {
        case TYVideoPlayerControllerEventTapScreen:
            [self setNeedsStatusBarAppearanceUpdate];
            break;
        default:
            break;
    }
}

#pragma mark - rotate

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //发生在翻转开始之前
    CGRect bounds = self.view.frame;
    [UIView animateWithDuration:duration animations:^{
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
             _playerController.view.frame = CGRectMake(0, 0, MAX(CGRectGetHeight(bounds), CGRectGetWidth(bounds)), MIN(CGRectGetHeight(bounds), CGRectGetWidth(bounds)));
        }else {
             _playerController.view.frame = CGRectMake(0, 0, MIN(CGRectGetHeight(bounds), CGRectGetWidth(bounds)), MIN(CGRectGetHeight(bounds), CGRectGetWidth(bounds))*9/16);
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
