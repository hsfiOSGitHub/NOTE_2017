//
//  SZBFmdbManager+firstSource.m
//  yuntangyi
//
//  Created by yuntangyi on 16/10/28.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBFmdbManager+firstSource.h"

#import "KnMeetingListModel.h"
#import "KnNewsListModel.h"

@implementation SZBFmdbManager (firstSource)
//将会议数据保存到本地数据库
-(void)saveFirstSourceMeetingDataIntoDBWithModelArr:(NSArray *)source{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"firstSourceMeeting.sqlite"];
    NSString *tableName = @"firstSourceMeeting";
    //先将老数据库中的数据全部清除
    [manager clearDatabase:db from:tableName];
    //将新数据插入到数据库
    //遍历
    for (KnMeetingListModel *model in source) {
        NSMutableString *tagStr = [NSMutableString string];
        if (model.tags_list.count > 0) {
            for (int i = 0; i < [model.tags_list count];i++) {
                [tagStr appendFormat:@"%@",model.tags_list[i]];
                if (i < [model.tags_list count] - 1) {
                    [tagStr appendString:@","];
                }
            }
        }
        
        NSDictionary *keyValues = @{@"id":model.knID,
                                    @"meeting_name":model.meeting_name,
                                    @"start_time":model.start_time,
                                    @"pic":model.pic,
                                    @"content":model.content,
                                    @"tags_list":tagStr,
                                    @"is_do":model.is_do,
                                    @"dotype":model.dotype,
                                    @"status":model.status};
        //执行插入
        [manager DataBase:db insertKeyValues:keyValues intoTable:tableName];
    }
}
//读取本地会议数据
-(NSArray *)readFirstSourceMeetingModelArrFromDB{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"firstSourceMeeting"];
    NSString *tableName = @"firstSourceMeeting";
    NSDictionary *keyTypes = @{@"id":@"text",
                               @"meeting_name":@"text",
                               @"start_time":@"text",
                               @"pic":@"text",
                               @"content":@"text",
                               @"tags_list":@"text",
                               @"is_do":@"text",
                               @"dotype":@"text",
                               @"status":@"text"};
    NSInteger limitNum = -1;
    //执行查询
    NSArray *result = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName limitNum:limitNum];
    //遍历
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSMutableDictionary *dic in result) {
        //先将tags_list转换为OC数组
        NSString *tagStr = dic[@"tags_list"];
        NSArray *tags_list = [tagStr componentsSeparatedByString:@","];
        [dic setObject:tags_list forKey:@"tags_list"];
        //转化为模型
        KnMeetingListModel *model = [KnMeetingListModel modelWithDict:dic];
        [tempArr addObject:model];
    }
    return tempArr;
}
//清除缓存
-(void)cleanDisk_FirstSourceMeetingList{
    //创建并打开数据库
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"firstSourceMeeting.sqlite"];
    NSString *tableName = @"firstSourceMeeting";
    //将老数据库中的数据全部清除
    [manager clearDatabase:db from:tableName];
}

//>>>>>>>>>>>>>>>>>>>>>>  NEWS   <<<<<<<<<<<<<<<<<<<<<<

//将资讯数据保存到本地数据库
-(void)saveFirstSourceNewDataIntoDBWithModelArr:(NSArray *)source withDBName:(NSString *)dbName{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:dbName];
    //先将老数据库中的数据全部清除
    [manager clearDatabase:db from:@"firstSourceNew"];
    //将新数据插入到数据库
    //遍历
    for (KnNewsListModel *model in source) {
        NSDictionary *keyValues = @{@"id":model.KnID,
                                    @"pic":model.pic,
                                    @"title":model.title,
                                    @"content":model.content,
                                    @"addtime":model.addtime,
                                    @"click":model.click,
                                    @"collect":model.collect,
                                    @"praise":model.praise,
                                    @"iscollect":model.iscollect,
                                    @"ispraise":model.ispraise,
                                    @"url":model.url};
        //执行插入
        [manager DataBase:db insertKeyValues:keyValues intoTable:@"firstSourceNews"];
    }
}
//读取本地资讯数据
-(NSArray *)readFirstSourceNewModelArrFromDB:(NSString *)dbName{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:dbName];
    NSString *tableName = @"firstSourceNews";
    NSDictionary *keyTypes = @{@"id":@"text",
                               @"pic":@"text",
                               @"title":@"text",
                               @"content":@"text",
                               @"addtime":@"text",
                               @"click":@"text",
                               @"collect":@"text",
                               @"praise":@"text",
                               @"iscollect":@"text",
                               @"ispraise":@"text",
                               @"url":@"text"};
    NSInteger limitNum = -1;
    //执行查询
    NSArray *result = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName limitNum:limitNum];
    //遍历
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSMutableDictionary *dic in result) {
        //转化为模型
        KnNewsListModel *model = [KnNewsListModel modelWithDict:dic];
        [tempArr addObject:model];
    }
    return tempArr;
}
//将数据库中的数据进行修改
-(void)modifyFirstSourceNewDataAtDBWith:(NSDictionary *)modifyDic withDBName:(NSString *)dbName whereCondition:(NSDictionary *)condition{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:dbName];
    NSString *tableName = @"firstSourceNews";
    //
    NSMutableDictionary *mtDic = [NSMutableDictionary dictionaryWithDictionary:modifyDic];
    [mtDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //为null
        if ([obj isKindOfClass:[NSNull class]]) {
            [mtDic removeObjectForKey:key];
        }
    }];
    //执行更新
    [manager DataBase:db updateTable:tableName setKeyValues:mtDic whereCondition:condition];
    
}

//清除缓存
-(void)cleanDisk_firstSourceNew{
    for (int i = 1; i < 4; i++) {
        //创建并打开数据库
        SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
        NSString *dbName = [NSString stringWithFormat:@"firstSourceNews%d.sqlite",i];
        FMDatabase *db = [manager getDBWithDBName:dbName];
        //先将老数据库中的数据全部清除
        [manager clearDatabase:db from:@"firstSourceNews"];
    }
}













@end
