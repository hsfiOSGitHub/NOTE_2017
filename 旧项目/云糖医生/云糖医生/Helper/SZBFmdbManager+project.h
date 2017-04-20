//
//  SZBFmdbManager+project.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBFmdbManager.h"

@interface SZBFmdbManager (project)
//将项目数据保存到数据库
-(void)saveProjectDataWithModelArr:(NSArray *)source;
//读取项目数据
-(NSArray *)readProjectModelArrFromDB;

//清除缓存
-(void)cleanDisk_projectList;
@end
