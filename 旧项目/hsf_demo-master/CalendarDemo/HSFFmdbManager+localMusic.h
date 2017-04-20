//
//  HSFFmdbManager+localMusic.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/20.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "HSFFmdbManager.h"

@interface HSFFmdbManager (localMusic)

//添加数据
-(void)insertLocalMusic:(MusicModel *)model;

//删除数据 --条件删除
-(void)deleteLocalMusicWhereCondition:(NSDictionary *)condition;

//数据修改 --条件修改
-(void)modifyLocalMusicWith:(MusicModel *)model whereCondition:(NSDictionary *)condition;

//读取数据 --全部数据
-(NSArray *)readAllLocalMusic;

//读取数据 --条件读取
-(NSArray *)readLocalMusicModelFromDBWhereCondition:(NSDictionary *)condition;

//清除缓存 --全部数据
-(void)cleanDisk_LocalMusic;

@end
