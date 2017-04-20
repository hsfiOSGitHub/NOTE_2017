//
//  SZBFmdbManager+meeting.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBFmdbManager.h"

@interface SZBFmdbManager (meeting)
//将会议数据保存到本地数据库
-(void)saveMeetingDataIntoDBWithModelArr:(NSArray *)source;
//读取本地会议数据
-(NSArray *)readMeetingModelArrFromDB;

//清除缓存
-(void)cleanDisk_meetingList;
@end
