//
//  TYVideoPlayerTrack.h
//  TYVideoPlayerDemo
//
//  Created by tany on 16/6/21.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TYVideoPlayerTrackType) {
    TYVideoPlayerTrackVOD,  // 点播
    TYVideoPlayerTrackLIVE, // 直播
    TYVideoPlayerTrackLocal // 本地
};

/**
 *  TYVideoPlayerTrack Protocol
 */
@protocol TYVideoPlayerTrack <NSObject>

// 视频流类型 点播 ，直播
@property (nonatomic, assign) TYVideoPlayerTrackType videoType;
// 视频地址
@property (nonatomic, strong) NSURL *streamURL;
// 是否播放结束
@property (nonatomic, assign) BOOL isPlayedToEnd;
// 是否之前载入过
@property (nonatomic, assign) BOOL isVideoLoadedBefore;
// 当前播放时间
@property (nonatomic, assign) NSInteger videoTime;
// 视频总时长
@property (nonatomic, assign) NSInteger videoDuration;
// 是否继续上次观看
@property (nonatomic, assign) BOOL continueLastWatchTime;
// 上次视频播放时间位置
@property (nonatomic, assign) NSInteger lastTimeInSeconds;

// syn or asyn get stream url
- (void)streamURLWithCompleteBlock:(void (^)(NSURL* url))completeBlock;


@end

@interface TYVideoPlayerTrack : NSObject<TYVideoPlayerTrack>

// 视频流类型 点播 ，直播
@property (nonatomic, assign) TYVideoPlayerTrackType videoType;
// 视频地址
@property (nonatomic, strong) NSURL *streamURL;
// 是否播放结束
@property (nonatomic, assign) BOOL isPlayedToEnd;
// 是否之前载入过
@property (nonatomic, assign) BOOL isVideoLoadedBefore;
// 当前播放时间
@property (nonatomic, assign) NSInteger videoTime;
// 视频总时长
@property (nonatomic, assign) NSInteger videoDuration;
// 是否继续上次观看
@property (nonatomic, assign) BOOL continueLastWatchTime;
// 上次视频播放时间位置
@property (nonatomic, assign) NSInteger lastTimeInSeconds;

- (id)initWithStreamURL:(NSURL*)url;

// 可以直接返回 或 异步请求获取返回StreamURL 默认直接返回
- (void)streamURLWithCompleteBlock:(void (^)(NSURL *))completeBlock;

- (void)resetTrack;

@end
