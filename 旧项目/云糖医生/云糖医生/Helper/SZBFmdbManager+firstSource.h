//
//  SZBFmdbManager+firstSource.h
//  yuntangyi
//
//  Created by yuntangyi on 16/10/28.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBFmdbManager.h"

@interface SZBFmdbManager (firstSource)
//将会议数据保存到本地数据库
-(void)saveFirstSourceMeetingDataIntoDBWithModelArr:(NSArray *)source;
//读取本地会议数据
-(NSArray *)readFirstSourceMeetingModelArrFromDB;
//清除缓存
-(void)cleanDisk_FirstSourceMeetingList;


//将资讯数据保存到本地数据库
-(void)saveFirstSourceNewDataIntoDBWithModelArr:(NSArray *)source withDBName:(NSString *)dbName;
//读取本地资讯数据
-(NSArray *)readFirstSourceNewModelArrFromDB:(NSString *)dbName;
//将数据库中的数据进行修改
-(void)modifyFirstSourceNewDataAtDBWith:(NSDictionary *)modifyDic withDBName:(NSString *)dbName whereCondition:(NSDictionary *)condition;
//清除缓存
-(void)cleanDisk_firstSourceNew;

@end
