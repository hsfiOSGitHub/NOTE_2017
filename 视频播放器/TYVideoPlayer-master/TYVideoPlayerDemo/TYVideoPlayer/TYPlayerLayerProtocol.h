//
//  TYVideoPlayeProtocol.h
//  TYVideoPlayerDemo
//
//  Created by tany on 16/7/8.
//  Copyright © 2016年 tany. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

/**
 *  TYPlayerLayer Protocol
 */
@protocol TYPlayerLayer <NSObject>

- (AVPlayerLayer *)playerLayer;

- (void)setPlayer:(AVPlayer *)player;

@end


