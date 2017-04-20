//
//  TYPlayerView.h
//  TYVideoPlayerDemo
//
//  Created by tany on 16/7/5.
//  Copyright © 2016年 tany. All rights reserved.
//  播放器播放层

#import <UIKit/UIKit.h>
#import "TYPlayerLayerProtocol.h"

@interface TYVideoPlayerView : UIView<TYPlayerLayer>

- (AVPlayerLayer *)playerLayer;

- (AVPlayer *)player;

- (void)setPlayer:(AVPlayer *)player;

@end
