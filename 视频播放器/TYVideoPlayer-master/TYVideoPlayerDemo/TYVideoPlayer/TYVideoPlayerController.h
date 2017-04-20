//
//  TYVideoPlayerController.h
//  TYVideoPlayerDemo
//
//  Created by tany on 16/7/6.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, TYVideoPlayerControllerEvent) {
    TYVideoPlayerControllerEventRotateScreen,   // 旋转屏幕 isFullScreen
    TYVideoPlayerControllerEventTapScreen,      // 单击屏幕 isControlViewHidden
    TYVideoPlayerControllerEventPlay,           // 播放
    TYVideoPlayerControllerEventSuspend,        // 暂停
};

@class TYVideoPlayerController;
@protocol TYVideoPlayerControllerDelegate <NSObject>
@optional

// 准备播放
- (void)videoPlayerController:(TYVideoPlayerController *)videoPlayerController readyToPlayURL:(NSURL *)streamURL;
// 播放结束
- (void)videoPlayerController:(TYVideoPlayerController *)videoPlayerController endToPlayURL:(NSURL *)streamURL;

// 事件
- (void)videoPlayerController:(TYVideoPlayerController *)videoPlayerController handleEvent:(TYVideoPlayerControllerEvent)event;

// 是否自定义退出控制器操作
- (BOOL)videoPlayerControllerShouldCustomGoBack:(TYVideoPlayerController *)videoPlayerController;

@end


@interface TYVideoPlayerController : UIViewController

@property (nonatomic, weak) id<TYVideoPlayerControllerDelegate> delegate;
// 视频名 默认YES
@property (nonatomic, strong) NSString *videoTitle;
// 播放地址
@property (nonatomic, strong) NSURL *streamURL;
// 加载完视频是否自动播放 默认YES
@property (nonatomic, assign) BOOL shouldAutoplayVideo;
// 是否全屏
@property (nonatomic, assign, readonly) BOOL isFullScreen;
// 控制层是否隐藏
@property (nonatomic, assign, readonly) BOOL isControlViewHidden;
// 视频缩放
@property (nonatomic, copy) NSString *videoGravity;
// 音量
@property (nonatomic, assign) float volume;
// 播放失败自动重试，默认2次 ，0 为不重试
@property (nonatomic, assign) NSInteger failedToAutoRetryCount;

// 加载视频URL，如果在viewDidLoad之前设置了streamURL 在viewDidLoad中将会自动调用这个
- (void)loadVideoWithStreamURL:(NSURL *)streamURL;

- (void)play;

- (void)pause;

- (void)stop;

@end
