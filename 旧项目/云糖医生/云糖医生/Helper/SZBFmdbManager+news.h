//
//  SZBFmdbManager+news.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBFmdbManager.h"

@interface SZBFmdbManager (news)
//将资讯数据保存到本地数据库
-(void)saveNewsDataIntoDBWithModelArr:(NSArray *)source withDBName:(NSString *)dbName;
//读取本地资讯数据
-(NSArray *)readNewsModelArrFromDB:(NSString *)dbName;
//将数据库中的数据进行修改
-(void)modifyNewsDataAtDBWith:(NSDictionary *)modifyDic withDBName:(NSString *)dbName whereCondition:(NSDictionary *)condition;

//清除缓存
-(void)cleanDisk_newsList;
@end
