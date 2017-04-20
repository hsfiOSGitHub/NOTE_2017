//
//  SZBFmdbManager+userInfo.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBFmdbManager+userInfo.h"
#import "UserInfoModel.h"

@implementation SZBFmdbManager (userInfo)
//将资讯数据保存到本地数据库
-(void)saveUserInfoDataIntoDBWithModelArr:(NSArray *)source{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"userInfo.sqlite"];
    NSString *tableName = @"userInfo";
    //先将老数据库中的数据全部清除
    [manager clearDatabase:db from:tableName];
    //将新数据插入到数据库
    //遍历
    for (NSDictionary *dic in source) {
        NSMutableDictionary *mtDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            //为null
            if ([obj isKindOfClass:[NSNull class]]) {
                [mtDic removeObjectForKey:key];
            }
        }];
        //执行插入
        [manager DataBase:db insertKeyValues:mtDic intoTable:tableName];
    }
}
//读取本地资讯数据
-(NSArray *)readUserInfoModelArrFromDB{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"userInfo.sqlite"];
    NSString *tableName = @"userInfo";
    NSDictionary *keyTypes = @{@"name":@"text",
                               @"gender":@"text",
                               @"age":@"text",
                               @"birth":@"text",
                               @"pic":@"text",
                               @"hid":@"text",
                               @"hospital":@"text",
                               @"did":@"text",
                               @"department":@"text",
                               @"title":@"text",
                               @"conent":@"text",
                               @"do_at":@"text",
                               @"is_check":@"text",
                               @"status":@"text",
                               @"auth_check":@"text",
                               @"ttid":@"text",
                               @"activity_id":@"text",
                               @"pospic_url":@"text",
                               @"id":@"text",
                               @"check_type": @"text",
                               @"login_type": @"text"};
    NSInteger limitNum = -1;
    //执行查询
    NSArray *result = [manager DataBase:db selectKeyTypes:keyTypes fromTable:tableName limitNum:limitNum];
    //遍历
    NSMutableArray *tempArr = [NSMutableArray array];
    for (NSMutableDictionary *dic in result) {
        //转化为模型
        UserInfoModel *model = [UserInfoModel modelWithDict:dic];
        [tempArr addObject:model];
    }
    return tempArr;
}

//将数据库中的数据进行修改
-(void)modifyUserInfoDataAtDBWith:(NSDictionary *)modifyDic{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"userInfo.sqlite"];
    NSString *tableName = @"userInfo";
    //
    NSMutableDictionary *mtDic = [NSMutableDictionary dictionaryWithDictionary:modifyDic];
    [mtDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //为null
        if ([obj isKindOfClass:[NSNull class]]) {
            [mtDic removeObjectForKey:key];
        }
    }];
    //执行更新
    [manager DataBase:db updateTable:tableName setKeyValues:mtDic];
    
}

//清除缓存
-(void)cleanDisk_userInfo{
    //创建并打开数据库
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"userInfo.sqlite"];
    NSString *tableName = @"userInfo";
    //先将老数据库中的数据全部清除
    [manager clearDatabase:db from:tableName];
}


@end
