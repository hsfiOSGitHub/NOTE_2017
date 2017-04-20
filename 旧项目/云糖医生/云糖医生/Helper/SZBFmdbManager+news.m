//
//  SZBFmdbManager+news.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBFmdbManager+news.h"
#import "KnNewsListModel.h"

@implementation SZBFmdbManager (news)
//将资讯数据保存到本地数据库
-(void)saveNewsDataIntoDBWithModelArr:(NSArray *)source withDBName:(NSString *)dbName{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:dbName];
    //先将老数据库中的数据全部清除
    [manager clearDatabase:db from:@"newsList"];
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
        [manager DataBase:db insertKeyValues:keyValues intoTable:@"newsList"];
    }
}
//读取本地资讯数据
-(NSArray *)readNewsModelArrFromDB:(NSString *)dbName{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:dbName];
    NSString *tableName = @"newsList";
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
-(void)modifyNewsDataAtDBWith:(NSDictionary *)modifyDic withDBName:(NSString *)dbName whereCondition:(NSDictionary *)condition{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:dbName];
    NSString *tableName = @"newsList";
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
-(void)cleanDisk_newsList{
    for (int i = 1; i < 4; i++) {
        //创建并打开数据库
        SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
        NSString *dbName = [NSString stringWithFormat:@"news%d.sqlite",i];
        FMDatabase *db = [manager getDBWithDBName:dbName];
        //先将老数据库中的数据全部清除
        [manager clearDatabase:db from:@"newsList"];
    }
}

@end
