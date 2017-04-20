# TYVideoPlayer
a video player for iOS，wrapper AVPlayer,and based on AVFoundation，highly custom.
<br>TYVideoPlayer是一个封装了AVPlayer的视频播放器组件，支持点播，直播和本地播放。
<br>TYVideoPlayerController是一个封装了TYVideoPlayer带播放UI的控制器。
<br>视频下载请看:[TYDownloadManager](https://github.com/12207480/TYDownloadManager)


## Requirements
* Xcode 6 or higher
* iOS 7.0 or higher
* ARC

## Features
* 支持点播，直播(HLS)和本地视频播放。
* 支持视频各种状态改变，播放进度，缓冲进度。
* 支持视频播放出错，加载超时，缓冲超时，seek超时等代理方法。
* 支持播放失败自动重试及次数设置。
* 支持视频继续上次观看时间位置。
* 支持高度自定义UI，全屏，包含丰富的代理方法。

## ScreenShot
![image](https://github.com/12207480/TYVideoPlayer/blob/master/ScreenShot/TYVideoPlayer.gif)

## Usage

### API
```objc
// 播放超时
typedef NS_ENUM(NSUInteger, TYVideoPlayerTimeOut) {
    // 开始加载超时
    TYVideoPlayerTimeOutLoad,
    // seek超时
    TYVideoPlayerTimeOutSeek,
    // 缓存超时
    TYVideoPlayerTimeOutBuffer,
};

// 播放状态
typedef NS_ENUM(NSUInteger, TYVideoPlayerState) {
    // 未知
    TYVideoPlayerStateUnknown,
    // 请求StreamURL
    TYVideoPlayerStateRequestStreamURL,
    // 加载中
    TYVideoPlayerStateContentLoading,
    // 准备播放
    TYVideoPlayerStateContentReadyToPlay,
    // 播放
    TYVideoPlayerStateContentPlaying,
    // 暂停播放
    TYVideoPlayerStateContentPaused,
    // 暂停卡顿缓冲中
    TYVideoPlayerStateBuffering,
    // seek
    TYVideoPlayerStateSeeking,
    // 停止播放
    TYVideoPlayerStateStopped,
    // 失败
    TYVideoPlayerStateError
};
```

### Delegate
```objc
@protocol TYVideoPlayerDelegate <NSObject>
@optional

// 是否应该播放
- (BOOL)videoPlayer:(TYVideoPlayer*)videoPlayer shouldPlayTrack:(id<TYVideoPlayerTrack>)track;

// 将要播放
- (void)videoPlayer:(TYVideoPlayer*)videoPlayer willPlayTrack:(id<TYVideoPlayerTrack>)track;

// 播放完成
- (void)videoPlayer:(TYVideoPlayer*)videoPlayer didEndToPlayTrack:(id<TYVideoPlayerTrack>)track;

// 是否应该改变状态
- (BOOL)videoPlayer:(TYVideoPlayer*)videoPlayer shouldChangeToState:(TYVideoPlayerState)toState;

// 将要改变状态
- (void)videoPlayer:(TYVideoPlayer*)videoPlayer track:(id<TYVideoPlayerTrack>)track willChangeToState:(TYVideoPlayerState)toState fromState:(TYVideoPlayerState)fromState;

// 已经改变状态
- (void)videoPlayer:(TYVideoPlayer*)videoPlayer track:(id<TYVideoPlayerTrack>)track didChangeToState:(TYVideoPlayerState)toState fromState:(TYVideoPlayerState)fromState;

// 播放时间定时更新（s）
- (void)videoPlayer:(TYVideoPlayer*)videoPlayer track:(id<TYVideoPlayerTrack>)track didUpdatePlayTime:(NSTimeInterval)playTime;

// 播放超时
- (void)videoPlayer:(TYVideoPlayer *)videoPlayer track:(id<TYVideoPlayerTrack>)track receivedTimeout:(TYVideoPlayerTimeOut)timeout;

// 播放出错
- (void)videoPlayer:(TYVideoPlayer*)videoPlayer track:(id<TYVideoPlayerTrack>)track receivedErrorCode:(TYVideoPlayerErrorCode)errorCode error:(NSError *)error;
@end

```
