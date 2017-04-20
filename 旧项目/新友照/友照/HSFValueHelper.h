//
//  HSFValueHelper.h
//  友照
//
//  Created by monkey2016 on 16/12/16.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSFValueHelper : NSObject
@property (nonatomic,strong) AVPlayer *lastPlayer;
@property (nonatomic,strong) AVPlayerLayer *lastPlayerLayer;
@property (nonatomic,strong) NSString *lastPath;//用于保存视频播放的路径
@property (nonatomic,assign) BOOL isReset;//正处于重置状态 

//单例的创建
+(instancetype)sharedHelper;

@end
