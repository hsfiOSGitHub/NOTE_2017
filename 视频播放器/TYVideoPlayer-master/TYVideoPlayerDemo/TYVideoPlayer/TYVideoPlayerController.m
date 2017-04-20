//
//  TYVideoPlayerController.m
//  TYVideoPlayerDemo
//
//  Created by tany on 16/7/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYVideoPlayerController.h"
#import "TYVideoPlayer.h"
#import "TYVideoPlayerView.h"
#import "TYVideoControlView.h"
#import "TYLoadingView.h"
#import "TYVideoErrorView.h"

@interface TYVideoPlayerController () <TYVideoPlayerDelegate, TYVideoControlViewDelegate>
{
    float _volume; // 音量
    NSInteger _curAutoRetryCount; // 当前重试次数
    BOOL _isDraging; // 正在拖拽
}

// 播放视图层
@property (nonatomic, weak) TYVideoPlayerView *playerView;
// 播放控制层
@property (nonatomic, weak) TYVideoControlView *controlView;
// 播放loading
@property (nonatomic, weak) TYLoadingView *loadingView;
// 播放错误view
@property (nonatomic, weak) TYVideoErrorView *errorView;

// 播放器
@property (nonatomic, strong) TYVideoPlayer *videoPlayer;

@end

@implementation TYVideoPlayerController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configrePropertys];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configrePropertys];
    }
    return self;
}

- (void)configrePropertys
{
    _shouldAutoplayVideo = YES;
    _failedToAutoRetryCount = 2;
    _videoGravity = AVLayerVideoGravityResizeAspect;
}

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addPlayerView];
    
    [self addLoadingView];
    
    [self addVideoControlView];
    
    [self addSingleTapGesture];
    
    [self addVideoPlayer];
    
    if (_streamURL) {
        [self loadVideoWithStreamURL:_streamURL];
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    _playerView.frame = self.view.bounds;
    _loadingView.center = _playerView.center;
    _controlView.frame = self.view.bounds;
    [_controlView setFullScreen:self.isFullScreen];
}

- (BOOL)prefersStatusBarHidden
{
    if (!self.isFullScreen) {
        return NO;
    }
    return [self isControlViewHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation )preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

#pragma mark - add subview

- (void)addPlayerView
{
    TYVideoPlayerView *playerView = [[TYVideoPlayerView alloc]init];
    playerView.backgroundColor = [UIColor blackColor];
    playerView.playerLayer.videoGravity = _videoGravity;
    [self.view addSubview:playerView];
    _playerView = playerView;
}

- (void)addVideoControlView
{
    TYVideoControlView *controlView = [[TYVideoControlView alloc]init];
    [controlView setTitle:_videoTitle];
    controlView.delegate = self;
    [self.view addSubview:controlView];
    _controlView = controlView;
}

- (void)addLoadingView
{
    TYLoadingView *loadingView = [[TYLoadingView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    loadingView.lineWidth = 1.5;
    [self.view addSubview:loadingView];
    _loadingView = loadingView;
}

- (void)addSingleTapGesture
{
    UITapGestureRecognizer *hideTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapAction:)];
    [_controlView addGestureRecognizer:hideTap];
}

#pragma mark - getter

- (BOOL)isFullScreen
{
    return [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight;
}

- (void)setVideoGravity:(NSString *)videoGravity
{
    _videoGravity = videoGravity;
    
    if (_playerView) {
        _playerView.playerLayer.videoGravity = videoGravity;
    }
}

- (float)volume {
    return _videoPlayer.volume;
}

- (void)setVolume:(float)volume {
    _volume = volume;
    
    if (!_videoPlayer.player) {
        return;
    }
    
    _videoPlayer.volume = volume;
}

#pragma mark - video player

- (void)addVideoPlayer
{
    TYVideoPlayer *videoPlayer = [[TYVideoPlayer alloc]initWithPlayerLayerView:_playerView];
    videoPlayer.delegate = self;
    _videoPlayer = videoPlayer;
}

#pragma mark - player control

- (void)loadVideoWithStreamURL:(NSURL *)streamURL
{
    _streamURL = streamURL;
    
    [_videoPlayer loadVideoWithStreamURL:streamURL];
}

- (void)play
{
    [_videoPlayer play];
}

- (void)pause
{
    [_videoPlayer pause];
}

- (void)stop
{
    [_videoPlayer stop];
}

#pragma mark - show & hide view

// show loadingView
- (void)showLoadingView
{
    if (!_loadingView.isAnimating && _videoPlayer.track.videoType != TYVideoPlayerTrackLocal) {
        [_controlView setPlayBtnHidden:YES];
        [_loadingView startAnimation];
    }
}

- (void)stopLoadingView
{
    if (_loadingView.isAnimating) {
        [_controlView setPlayBtnHidden:NO];
        [_loadingView stopAnimation];
    }
}

// show ControlView
- (void)showControlViewWithAnimation:(BOOL)animation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
    
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setControlViewHidden:NO];
        }];
    }else {
        [self setControlViewHidden:NO];
    }
    [_controlView setPlayBtnHidden:[_loadingView isAnimating]];
}

- (void)hideControlViewWithAnimation:(BOOL)animation
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
    
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self setControlViewHidden:YES];
        }];
    }else {
        [self setControlViewHidden:YES];
    }
}

- (void)setControlViewHidden:(BOOL)hidden
{
    [_controlView setContentViewHidden:hidden];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)isControlViewHidden
{
    return [_controlView contentViewHidden];
}

- (void)hideControlViewWithDelay:(CGFloat)delay
{
    if (delay > 0) {
        [self performSelector:@selector(hideControlView) withObject:nil afterDelay:delay];
    }else {
        [self hideControlView];
    }
}

- (void)hideControlView
{
    if (![self isControlViewHidden]  && !_isDraging) {
        [self hideControlViewWithAnimation:YES];
    };
}

// show errorView
- (void)showErrorViewWithTitle:(NSString *)title actionHandle:(void (^)(void))actionHandle
{
    if (!_errorView) {
        TYVideoErrorView *errorView = [[TYVideoErrorView alloc]initWithFrame:self.view.bounds];
        errorView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self.view addSubview:errorView];
        _errorView = errorView;
    }
    
    __weak typeof(self) weakSelf = self;
    [_errorView setTitle:title];
    [_errorView setEventActionHandle:^(TYVideoErrorEvent event) {
        switch (event) {
            case TYVideoErrorEventBack:
                [weakSelf goBackAction];
                break;
            case TYVideoErrorEventReplay:
                if (actionHandle) {
                    actionHandle();
                }
                break;
            default:
                break;
        }
    }];
}

- (void)hideErrorView
{
    if (_errorView) {
        [_errorView removeFromSuperview];
    }
}

#pragma mark - private

- (BOOL)autoRetryLoadCurrentVideo
{
    if (_curAutoRetryCount++ < _failedToAutoRetryCount) {
        NSLog(@"autoRetryLoadCurrentVideoCount %ld",(long)_curAutoRetryCount);
        [self reloadCurrentVideo];
        return YES;
    }
    return NO;
}

- (void)playerViewDidChangeToState:(TYVideoPlayerState)state
{
    switch (state) {
        case TYVideoPlayerStateRequestStreamURL:
            [self hideErrorView];
            [self showLoadingView];
            if (_shouldAutoplayVideo) {
                [self hideControlViewWithAnimation:NO];
            }
            [_controlView setSliderProgress:0];
            [_controlView setBufferProgress:0];
            [_controlView setCurrentVideoTime:@"00:00"];
            [_controlView setTotalVideoTime:@"00:00"];
            break;
        case TYVideoPlayerStateContentReadyToPlay:
        {
            NSString *totalTime = [self covertToStringWithTime:[_videoPlayer duration]];
            NSString *currentTime = [self covertToStringWithTime:[_videoPlayer currentTime]];
            [_controlView setTotalVideoTime:totalTime];
            [_controlView setCurrentVideoTime:currentTime];
            [_controlView setSliderProgress:[_videoPlayer currentTime]/[_videoPlayer duration]];
            [_controlView setTimeSliderHidden:_videoPlayer.track.videoType == TYVideoPlayerTrackLIVE];
            if (_shouldAutoplayVideo) {
                [self hideControlViewWithDelay:5.0];
            }else {
                [self stopLoadingView];
            }
            break;
        }
        case TYVideoPlayerStateContentPlaying:
            [self hideErrorView];
            [_controlView setPlayBtnState:NO];
            [_controlView setPlayBtnHidden:NO];
            [self stopLoadingView];
            break;
        case TYVideoPlayerStateContentPaused:
            [_controlView setPlayBtnState:YES];
            break;
        case TYVideoPlayerStateSeeking:
            [self showLoadingView];
            break;
        case TYVideoPlayerStateBuffering:
            [self showLoadingView];
            break;
        case TYVideoPlayerStateStopped:
            [self stopLoadingView];
            [_controlView setPlayBtnHidden:YES];
            break;
        case TYVideoPlayerStateError:
            [self stopLoadingView];
            [_controlView setPlayBtnHidden:YES];
            break;
        default:
            break;
    }
}

- (void)player:(TYVideoPlayer*)videoPlayer didChangeToState:(TYVideoPlayerState)state
{
    // player control
    switch (state) {
        case TYVideoPlayerStateContentReadyToPlay:
            if (_shouldAutoplayVideo) {
                [videoPlayer play];
            }
            if ([_delegate respondsToSelector:@selector(videoPlayerController:readyToPlayURL:)]) {
                [_delegate videoPlayerController:self readyToPlayURL:videoPlayer.track.streamURL];
            }
            break;
        case TYVideoPlayerStateContentPlaying:
            _curAutoRetryCount = 0;
            break;
        case TYVideoPlayerStateError:
            if (![self autoRetryLoadCurrentVideo]) {
                __weak typeof(self) weakSelf = self;
                [self showErrorViewWithTitle:@"视频播放失败,重试" actionHandle:^{
                    [weakSelf reloadCurrentVideo];
                }];
            }
            break;
        default:
            break;
    }
}

- (void)handelControllerEvent:(TYVideoPlayerControllerEvent)event
{
    if ([_delegate respondsToSelector:@selector(videoPlayerController:handleEvent:)]) {
        [_delegate videoPlayerController:self handleEvent:event];
    }
}

- (NSString *)covertToStringWithTime:(NSInteger)time
{
    NSInteger seconds = time % 60;
    NSInteger minutes = time / 60;
    return [NSString stringWithFormat:@"%02ld:%02ld",(long)minutes,(long)seconds];
}

#pragma mark - action

- (void)reloadVideo
{
    [self loadVideoWithStreamURL:_streamURL];
    [self hideErrorView];
}

- (void)reloadCurrentVideo
{
    self.videoPlayer.track.continueLastWatchTime = YES;
    [self.videoPlayer reloadCurrentVideoTrack];
    [self hideErrorView];
}

- (void)singleTapAction:(UITapGestureRecognizer *)tap
{
    if ([self isControlViewHidden]) {
        [self showControlViewWithAnimation:YES];
    }else {
        [self hideControlViewWithAnimation:YES];
    }
    [self handelControllerEvent:TYVideoPlayerControllerEventTapScreen];
}

- (void)goBackAction
{
    if (self.isFullScreen){
        [self changeToOrientation:UIInterfaceOrientationPortrait];
    }else {
        [self goBack];
    }
}

- (void)goBack
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControlView) object:nil];
    [self stop];
    
    if ([_delegate respondsToSelector:@selector(videoPlayerControllerShouldCustomGoBack:)]
         && [_delegate videoPlayerControllerShouldCustomGoBack:self]) {
        return;
    }
    
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - TYVideoPlayerDelegate

// 状态改变
- (void)videoPlayer:(TYVideoPlayer*)videoPlayer track:(id<TYVideoPlayerTrack>)track didChangeToState:(TYVideoPlayerState)toState fromState:(TYVideoPlayerState)fromState
{
    // update UI
    [self playerViewDidChangeToState:toState];
    
    // player control
    [self player:videoPlayer didChangeToState:toState];
}

// 更新时间
- (void)videoPlayer:(TYVideoPlayer *)videoPlayer track:(id<TYVideoPlayerTrack>)track didUpdatePlayTime:(NSTimeInterval)playTime
{
    if (_isDraging) {
        return;
    }
    
    NSString *time = [self covertToStringWithTime:playTime];
    [_controlView setCurrentVideoTime:time];
    NSTimeInterval duration = [videoPlayer duration];
    NSTimeInterval availableDuration = [videoPlayer availableDuration];
    if (duration <= 0) {
        [_controlView setSliderProgress:0];
        [_controlView setBufferProgress:0];
    }else {
        [_controlView setSliderProgress:playTime/duration];
        [_controlView setBufferProgress:MIN(availableDuration/duration, 1.0)];
    }
}

// 播放结束
- (void)videoPlayer:(TYVideoPlayer *)videoPlayer didEndToPlayTrack:(id<TYVideoPlayerTrack>)track
{
    NSLog(@"播放完成！");
    
    [_controlView setPlayBtnHidden:YES];
    
    __weak typeof(self) weakSelf = self;
    [self showErrorViewWithTitle:@"重播" actionHandle:^{
        [weakSelf reloadVideo];
    }];
    
    if ([_delegate respondsToSelector:@selector(videoPlayerController:endToPlayURL:)]) {
        [_delegate videoPlayerController:self endToPlayURL:videoPlayer.track.streamURL];
    }
}

// 播放错误
- (void)videoPlayer:(TYVideoPlayer *)videoPlayer track:(id<TYVideoPlayerTrack>)track receivedErrorCode:(TYVideoPlayerErrorCode)errorCode error:(NSError *)error
{
    NSLog(@"videoPlayer receivedErrorCode %@",error);
    
    if ([self autoRetryLoadCurrentVideo]) {
        return;
    }
    [_loadingView stopAnimation];
    [_controlView setPlayBtnHidden:YES];
    
    __weak typeof(self) weakSelf = self;
    [self showErrorViewWithTitle:@"视频播放失败,重试" actionHandle:^{
        [weakSelf reloadCurrentVideo];
    }];
}

// 播放超时
- (void)videoPlayer:(TYVideoPlayer *)videoPlayer track:(id<TYVideoPlayerTrack>)track receivedTimeout:(TYVideoPlayerTimeOut)timeout
{
    NSLog(@"videoPlayer receivedTimeout %ld",(unsigned long)timeout);
    
    if ([self autoRetryLoadCurrentVideo]) {
        return;
    }
    [_loadingView stopAnimation];
    [_controlView setPlayBtnHidden:YES];
    
    __weak typeof(self) weakSelf = self;
    [self showErrorViewWithTitle:@"视频播放超时,重试" actionHandle:^{
        [weakSelf reloadCurrentVideo];
    }];
}

#pragma mark - TYVideoControlViewDelegate

- (BOOL)videoControlView:(TYVideoControlView *)videoControlView shouldResponseControlEvent:(TYVideoControlEvent)event
{
     switch (event) {
         case TYVideoControlEventPlay:
             return _videoPlayer.state == TYVideoPlayerStateContentPaused || _videoPlayer.state == TYVideoPlayerStateContentReadyToPlay;
         case TYVideoControlEventSuspend:
             return [_videoPlayer isPlaying];
         default:
             return YES;
     }
}

- (void)videoControlView:(TYVideoControlView *)videoControlView recieveControlEvent:(TYVideoControlEvent)event
{
    switch (event) {
        case TYVideoControlEventBack:
            [self goBackAction];
            break;
        case TYVideoControlEventFullScreen:
            [self changeToOrientation:UIInterfaceOrientationLandscapeRight];
            [self handelControllerEvent:TYVideoPlayerControllerEventRotateScreen];
            break;
        case TYVideoControlEventNormalScreen:
            [self changeToOrientation:UIInterfaceOrientationPortrait];
            [self handelControllerEvent:TYVideoPlayerControllerEventRotateScreen];
            break;
        case TYVideoControlEventPlay:
            [self play];
            [self handelControllerEvent:TYVideoPlayerControllerEventPlay];
            break;
        case TYVideoControlEventSuspend:
            [self pause];
            [self handelControllerEvent:TYVideoPlayerControllerEventSuspend];
            break;
        default:
            break;
    }
}

- (void)videoControlView:(TYVideoControlView *)videoControlView state:(TYSliderState)state sliderToProgress:(CGFloat)progress
{
    switch (state) {
        case TYSliderStateBegin:
            _isDraging = YES;
            break;
        case TYSliderStateDraging:
        {
            NSTimeInterval sliderTime = floor([_videoPlayer duration]*progress);
            NSString *time = [self covertToStringWithTime:sliderTime];
            [_controlView setCurrentVideoTime:time];
            break;
        }
        case TYSliderStateEnd:
        {
            _isDraging = NO;
            NSTimeInterval sliderTime = floor([_videoPlayer duration]*progress);
            NSString *time = [self covertToStringWithTime:sliderTime];
            [_videoPlayer seekToTime:sliderTime];
            [_controlView setCurrentVideoTime:time];
            [self hideControlViewWithAnimation:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark - Autorotate

- (void)changeToOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        UIInterfaceOrientation val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self stop];
}

@end
