
//
//  MusicPlayerHelper.m
//  News
//
//  Created by monkey2016 on 16/10/26.
//  Copyright © 2016年 monkey2016. All rights reserved.
//
/**
 
 音频格式转换可以使用终端的命令行进行转换，基本使用：afconvert -f [格式] -d [fileName]
 具体使用可以使用help查看：afconvert -help
 afconvert: audio format convert 音频格式转换
 */
#import "MusicPlayerHelper.h"
#import <AVFoundation/AVFoundation.h>

static NSMutableDictionary *_soundDict;//存放所有的音频ID,fileName作为key,SoundID作为value
static NSMutableDictionary *_musicDict;//存放所有的音乐播放器,fileName作为key,audioPlayer作为value

@implementation MusicPlayerHelper

#pragma mark 初始化字典
+(void)initialize
{
    
    //存放所有的音频ID,fileName作为key,SoundID作为value
    _soundDict = [NSMutableDictionary dictionary];
    
    //存放所有的音乐播放器,fileName作为key,audioPlayer作为value
    _musicDict = [NSMutableDictionary dictionary];
    
    //设置音频会话类型
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategorySoloAmbient error:nil];
    [session setActive:YES error:nil];
}

#pragma mark 播放音效
+(void)playSound:(NSString *)fileName
{
    
    //判断文件名是否为空
    if (!fileName)  return;
    
    //加载音效文件(短音频)   记住:每一个音效对应一个ID
    SystemSoundID soundID = [_soundDict[fileName] unsignedIntValue];
    if (!soundID) {
        NSURL *url = [[NSBundle mainBundle]URLForResource:fileName withExtension:nil];
        
        if (!url) return;
        
        //创建音效sound ID
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        
        //存入字典
        [_soundDict setObject:[NSNumber numberWithUnsignedInt:soundID] forKey:fileName];
        
        //使用sound ID播放
        AudioServicesPlaySystemSound(soundID);
        //AudioServicesPlayAlertSound(SystemSoundID inSystemSoundID)  //播放时手机会震动
    }
}

#pragma mark 销毁音效
+(void)disposeSound:(NSString *)fileName
{

    //判断文件名是否为空
    if (!fileName)  return;
    
    //从字典中取出ID
    SystemSoundID soundID = (SystemSoundID)[[_soundDict objectForKey:fileName] unsignedIntValue];
    
    //释放音效资源
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        [_soundDict removeObjectForKey:fileName];
    }
}


#pragma mark 播放音乐
+(AVAudioPlayer *)playMusic:(NSString *)fileName
{
    
    //判断文件名是否为空
    if (!fileName)  return nil;
    
    //从字典中取出播放器
    AVAudioPlayer *audioPlayer = _musicDict[fileName];
    audioPlayer.currentTime = 0;//从头播放
    
    if (!audioPlayer){
        //加载音乐文件
        NSError *error = nil;
        NSURL *url = [[NSBundle mainBundle]URLForResource:fileName withExtension:nil];
        if (!url) return nil;
        
        //创建播放器
        audioPlayer = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        
        //播放速率、音量、当前时间等
        //audioPlayer.enableRate = YES;
        //audioPlayer.rate = 5.0f;
        //audioPlayer.volume = 20.0f;
        //audioPlayer.currentTime = 100.0f;
        
        
        if (error) return nil;
        
        //将播放器存入字典中
        [_musicDict setObject:audioPlayer forKey:fileName];
        
        //创建缓冲(以便后面的播放流畅)
        [audioPlayer prepareToPlay];
        
        //开始播放
        [audioPlayer play];
    }
    
    if (!audioPlayer.isPlaying)
    {
        //开始播放
        [audioPlayer play];
    }
    
    return audioPlayer;
}


#pragma mark 暂停音乐
+(void)pauseMusic:(NSString *)fileName
{
    
    //判断文件名是否为空
    if (!fileName)  return;
    
    //从字典中取出播放器
    AVAudioPlayer *audioPlayer = _musicDict[fileName];
    
    //暂停
    if (audioPlayer && audioPlayer.isPlaying) {
        [audioPlayer pause];
    }
}


#pragma mark 停止音乐
+(void)stopMusic:(NSString *)fileName
{
    
    //判断文件名是否为空
    if (!fileName)  return;
    
    //从字典中取出播放器
    AVAudioPlayer *audioPlayer = _musicDict[fileName];
    
    //停止并移除播放器
    if (audioPlayer && audioPlayer.isPlaying)
    {
        [audioPlayer stop];
        [_musicDict removeObjectForKey:fileName];
    }
}

#pragma mark -停止音乐 把isPlaying字段改为0
+(NSMutableDictionary *)stopMusicWithFileName:(NSString *)fileName andCurrentDic:(NSMutableDictionary *)dic{
    [self stopMusic:fileName];
    //更改isPlaying字段
    [dic setObject:@"0" forKey:@"isPlaying"];
    return dic;
}

#pragma mark 返回当前进度下的播放器
+(AVAudioPlayer *)currentPlayingAudioPlayer
{
    for(NSString *fileName in _musicDict) {
        AVAudioPlayer *audioplayer = _musicDict[fileName];
        
        if (audioplayer.isPlaying) {
            return audioplayer;
        }
    }
    return nil;
}
@end
