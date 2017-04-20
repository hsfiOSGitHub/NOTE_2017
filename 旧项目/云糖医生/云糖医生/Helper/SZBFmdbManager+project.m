//
//  SZBFmdbManager+project.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBFmdbManager+project.h"
#import "PrActivityListModel.h"

@implementation SZBFmdbManager (project)
//将项目数据保存到数据库
-(void)saveProjectDataWithModelArr:(NSArray *)source{
    //将数据保存到数据库中
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    //创建并打开数据库
    FMDatabase *db = [manager getDBWithDBName:@"project.sqlite"];
    NSString *tableName = @"projectList";
    //先将数据库中的数据全部清除
    [manager clearDatabase:db from:tableName];
    //遍历
    for (PrActivityListModel *model in source) {
        NSDictionary *keyValues = @{@"activity_id":model.activity_id,
                                    @"title":model.title,
                                    @"pic":model.pic,
                                    @"type_name":model.type_name,
                                    @"content":model.content,
                                    @"activity_url":model.activity_url,
                                    @"join_num":model.join_num,
                                    @"join_status":model.join_status};
        //执行插入
        [manager DataBase:db insertKeyValues:keyValues intoTable:tableName];
    }
}
//读取项目数据
-(NSArray *)readProjectModelArrFromDB{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"project.sqlite"];
    NSString *tableName = @"projectList";
    NSDictionary *keyTypes = @{@"activity_id":@"text",
                               @"title":@"text",
                               @"pic":@"text",
                               @"type_name":@"text",
                               @"content":@"text",
                               @"activity_url":@"text",
                               @"join_num":@"text",
                               @"join_status":@"text"};
    NSInteger limitNum = -1;
    //执行查询
    NSArray *result = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName limitNum:limitNum];
    //遍历
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSMutableDictionary *dic in result) {
        //转化为模型
        PrActivityListModel *model = [PrActivityListModel modelWithDict:dic];
        [tempArr addObject:model];
    }
    return tempArr;
}
//清除缓存
-(void)cleanDisk_projectList{
    //创建并打开数据库
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"project.sqlite"];
    NSString *tableName = @"projectList";
    //将数据库中的数据全部清除
    [manager clearDatabase:db from:tableName];
}






@end
