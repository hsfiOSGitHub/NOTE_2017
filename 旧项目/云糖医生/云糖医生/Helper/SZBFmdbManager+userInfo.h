//
//  SZBFmdbManager+userInfo.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBFmdbManager.h"

@interface SZBFmdbManager (userInfo)
//将资讯数据保存到本地数据库
-(void)saveUserInfoDataIntoDBWithModelArr:(NSArray *)source;
//读取本地资讯数据
-(NSArray *)readUserInfoModelArrFromDB;
//将数据库中的数据进行修改
-(void)modifyUserInfoDataAtDBWith:(NSDictionary *)modifyDic;

//清除缓存
-(void)cleanDisk_userInfo;
@end
