//
//  MusicVC.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/19.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MusicVCDelegate <NSObject>

@optional

-(void)backToLocalMusicListVCWithCurrentPlayListArr:(NSMutableArray *)currentPlayListArr andCurrentPlayIndex:(NSInteger)currentPlayIndex andPlayer:(AVAudioPlayer *)player andCurrentPlayMode:(MusicMode)currentPlayMode;

@end

@interface MusicVC : UIViewController


@property (nonatomic,strong) AVAudioPlayer *player;//音乐播放器
@property (nonatomic,assign) id<MusicVCDelegate> delegate;
@property (nonatomic,strong) NSMutableArray *currentPlayListArr;//当前播放列表
@property (nonatomic,assign) NSInteger currentPlayIndex;//当前播放下标
@property (nonatomic,assign) MusicMode currentPlayMode;//当前播放模式

@end
