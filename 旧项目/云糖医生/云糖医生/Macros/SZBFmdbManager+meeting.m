//
//  SZBFmdbManager+meeting.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SZBFmdbManager+meeting.h"

#import "KnMeetingListModel.h"

@implementation SZBFmdbManager (meeting)
//将会议数据保存到本地数据库
-(void)saveMeetingDataIntoDBWithModelArr:(NSArray *)source{

    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"meeting.sqlite"];
    NSString *tableName = @"meetingList";
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
-(NSArray *)readMeetingModelArrFromDB{
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"meeting.sqlite"];
    NSString *tableName = @"meetingList";
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
-(void)cleanDisk_meetingList{
    //创建并打开数据库
    SZBFmdbManager *manager = [SZBFmdbManager sharedManager];
    FMDatabase *db = [manager getDBWithDBName:@"meeting.sqlite"];
    NSString *tableName = @"meetingList";
    //将老数据库中的数据全部清除
    [manager clearDatabase:db from:tableName];
}


@end
