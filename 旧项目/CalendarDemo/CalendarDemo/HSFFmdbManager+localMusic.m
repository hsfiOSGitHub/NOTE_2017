//
//  HSFFmdbManager+localMusic.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/20.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "HSFFmdbManager+localMusic.h"

@implementation HSFFmdbManager (localMusic)

//添加数据
-(void)insertLocalMusic:(MusicModel *)model{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"localMusic.sqlite"];
    NSString *tableName = @"localMusic";
    //数据
    NSDictionary *dic = @{@"musicName":model.musicName,
                          @"singerName":model.singerName,
                          @"type":model.type,
                          @"singerPic":model.singerPic,
                          @"is_playing":model.is_playing,
                          @"isLike":model.isLike};
    
    NSMutableDictionary *mtDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //为null时移除,不插入数据库
        if ([obj isKindOfClass:[NSNull class]]) {
            [mtDic removeObjectForKey:key];
        }
    }];
    //添加
    [manager DataBase:db insertKeyValues:mtDic intoTable:tableName];
}

//删除数据 --条件删除
-(void)deleteLocalMusicWhereCondition:(NSDictionary *)condition{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"localMusic.sqlite"];
    NSString *tableName = @"localMusic";
    [manager DataBase:db deleteFromTable:tableName whereCondition:condition];
}

//数据修改 --条件修改
-(void)modifyLocalMusicWith:(MusicModel *)model whereCondition:(NSDictionary *)condition{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"localMusic.sqlite"];
    NSString *tableName = @"localMusic";
    //数据
    NSDictionary *dic = @{@"musicName":model.musicName,
                          @"singerName":model.singerName,
                          @"type":model.type,
                          @"singerPic":model.singerPic,
                          @"is_playing":model.is_playing,
                          @"isLike":model.isLike};
    
    NSMutableDictionary *mtDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //为null时移除,不插入数据库
        if ([obj isKindOfClass:[NSNull class]]) {
            [mtDic removeObjectForKey:key];
        }
    }];
    //修改
    [manager DataBase:db updateTable:tableName setKeyValues:mtDic whereCondition:condition];
}

//读取数据 --全部数据
-(NSArray *)readAllLocalMusic{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"localMusic.sqlite"];
    NSString *tableName = @"localMusic";
    //数据
    NSDictionary *keyTypes = @{@"musicName":@"text",
                               @"singerName":@"text",
                               @"type":@"text",
                               @"singerPic":@"text",
                               @"is_playing":@"text",
                               @"isLike":@"text"};
    
    NSInteger limitNum = -1;
    //执行查询
    NSArray *result = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName limitNum:limitNum];
    //转模型
    NSMutableArray *modelResult = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MusicModel *model = [MusicModel modelWithDic:obj];
        [modelResult addObject:model];
    }];
    return modelResult;
}

//读取数据 --条件读取
-(NSArray *)readLocalMusicModelFromDBWhereCondition:(NSDictionary *)condition{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"localMusic.sqlite"];
    NSString *tableName = @"localMusic";
    //数据
    NSDictionary *keyTypes = @{@"musicName":@"text",
                               @"singerName":@"text",
                               @"type":@"text",
                               @"singerPic":@"text",
                               @"is_playing":@"text",
                               @"isLike":@"text"};
    
    NSInteger limitNum = -1;
    //执行查询
    NSArray *result = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName whereCondition:condition limitNum:limitNum];
    //转模型
    NSMutableArray *modelResult = [NSMutableArray array];
    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        MusicModel *model = [MusicModel modelWithDic:obj];
        [modelResult addObject:model];
    }];
    return modelResult;
}

//清除缓存 --全部数据
-(void)cleanDisk_LocalMusic{
    HSFFmdbManager *manager = [HSFFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"localMusic.sqlite"];
    NSString *tableName = @"localMusic";
    //将数据库中的数据全部清除
    [manager clearDatabase:db from:tableName];
}

@end
