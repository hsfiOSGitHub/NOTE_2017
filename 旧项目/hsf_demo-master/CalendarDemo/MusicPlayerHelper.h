//
//  MusicPlayerHelper.h
//  News
//
//  Created by monkey2016 on 16/10/26.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(NSInteger, MusicMode) {
    MusicModeOrder = 0,//顺序播放（默认）
    MusicModeLoop = 1,//循环播放
    MusicModeRandom = 2,//随机播放
    MusicModeSingle = 3,//单曲循环
};

@interface MusicPlayerHelper : NSObject

//播放音效
/**
 @param   fileName : 音效文件名
 */
+(void)playSound:(NSString *)fileName;


//销毁音效
/**
 @param   fileName : 音效文件名
 */
+(void)disposeSound:(NSString *)fileName;



//播放音乐
/**
 @param   fileName : 音乐文件名
 */
+(AVAudioPlayer*)playMusic:(NSString *)fileName;


//暂停播放音乐
/**
 @param   fileName : 音乐文件名
 */
+(void)pauseMusic:(NSString *)fileName;


//停止播放音乐
/**
 @param   fileName : 音乐文件名
 */
+(void)stopMusic:(NSString *)fileName;

#pragma mark -停止音乐 把isPlaying字段改为0
+(NSMutableDictionary *)stopMusicWithFileName:(NSString *)fileName andCurrentDic:(NSMutableDictionary *)dic;


//返回当前进度下的播放器
+(AVAudioPlayer *)currentPlayingAudioPlayer;

@end
