//
//  HSFHelper.h
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/26.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSFHelper : NSObject

//日程
@property (nonatomic,assign) CGRect todayBtnRect_cell;
@property (nonatomic,assign) CGRect todayBtnRect_top;
//用于音乐播放器(小空间)
@property (nonatomic,strong) AVAudioPlayer *currentPlayer;

//单例的初始化方法
+(instancetype)sharedHelper;


@end
