//
//  ZXTopicManager.m
//  ZXJiaXiao
//
//  Created by ZX on 16/2/26.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXTopicManager.h"
#import "FMDatabase.h"
@interface ZXTopicManager()
@property (nonatomic ,strong) FMDatabase  *db;
@end

@implementation ZXTopicManager
+ (instancetype)sharedTopicManager
{
    static ZXTopicManager *manager = nil;
    @synchronized(self) {
        if (manager == nil) {
            manager = [[ZXTopicManager alloc] init];
        }
    }
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        
        //2. 通过 NSFileManager 对象 fm 来判断文件是否存在，存在 返回YES  不存在返回NO
        BOOL isExist = [fm fileExistsAtPath:KfilePath];
        YZLog(@"%@",KfilePath);
        //如果不存在 isExist = NO，拷贝工程里的数据库到Documents下
        if (!isExist)
        {
            //拷贝数据库
            YZLog(@"数据库不存在");
            //获取工程里，数据库的路径,因为我们已在工程中添加了数据库文件，所以我们要从工程里获取路径
            NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:@"exercises" ofType:@"db"];
            //这一步实现数据库的添加，
            // 通过NSFileManager 对象的复制属性，把工程中数据库的路径拼接到应用程序的路径上
            [fm copyItemAtPath:backupDbPath toPath:KfilePath error:nil];
        }
        //1. 创建一个数据库的实例,仅仅在创建一个实例，并会打开数据库
        _db = [FMDatabase databaseWithPath:KfilePath];
        [_db open];
    }
    return self;
}

//读取所有科一的试题
- (NSMutableArray *)readAllSubject1Topics
{
    NSMutableArray *subject1Topics = [NSMutableArray array];
    NSString *sql = @"select * from web_note where kemu = 1 and LicenseType like '%C1C2C3%'";
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next)
    {
        [self dealWithTopics:result andArrar:subject1Topics];
    }
    return subject1Topics;
}

//读取所有科一专项的试题
- (NSMutableArray *)readAllSubject1Topics:(NSString*)Type
{
    NSMutableArray *subject1Topics = [NSMutableArray array];
    NSString *sql =[NSString stringWithFormat:@""
                    @"select * from web_note where kemu = 1 and moretypes like \'%%%@%%\' and LicenseType like \'%%C1C2C3%%\'",Type];
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next)
    {
        [self dealWithTopics:result andArrar:subject1Topics];
    }
    return subject1Topics;
}

//读取所有科四专项的试题
- (NSMutableArray *)readAllSubject4Topics:(NSString*)Type
{
    NSMutableArray *subject1Topics = [NSMutableArray array];
    NSString *sql =[NSString stringWithFormat:@""
                    @"select * from web_note where kemu = 4 and moretypes like \'%%%@%%\'",Type];
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next)
    {
        [self dealWithTopics:result andArrar:subject1Topics];
    }
    return subject1Topics;
}

//读取所有科四的试题
- (NSMutableArray *)readAllSubject4Topics
{
    NSMutableArray *subject1Topics = [NSMutableArray array];
    NSString *sql = @"select * from web_note where kemu = 4 and LicenseType like '%C1C2C3%'";
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next)
    {
        [self dealWithTopics:result andArrar:subject1Topics];
    }
    return subject1Topics;
}

//读取所有科一收藏的题
- (NSMutableArray *)readClass1AllFavTopics {
    NSMutableArray *subject1Topics = [NSMutableArray array];
    NSString *sql = @"select * from web_Fav WHERE kemu = 1";
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next)
    {
        [self dealWithTopics:result andArrar:subject1Topics];
    }
    return subject1Topics;
}
//读取所有科四收藏的题
- (NSMutableArray *)readClass4AllFavTopics {
    NSMutableArray *subject1Topics = [NSMutableArray array];
    NSString *sql = @"select * from web_Fav WHERE kemu = 4";
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next)
    {
        [self dealWithTopics:result andArrar:subject1Topics];
    }
    return subject1Topics;
}

//读取所有科一的错题
- (NSMutableArray *)readClass1AllWrongTopics {
    NSMutableArray *subject1Topics = [NSMutableArray array];
    NSString *sql = @"select * from web_Error  WHERE kemu = 1";
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next)
    {
        [self dealWithTopics:result andArrar:subject1Topics];
    }
    return subject1Topics;
}
//读取所有科四的错题
- (NSMutableArray *)readClass4AllWrongTopics {
    NSMutableArray *subject1Topics = [NSMutableArray array];
    NSString *sql = @"select * from web_Error  WHERE kemu = 4";
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next)
    {
        [self dealWithTopics:result andArrar:subject1Topics];
    }
    return subject1Topics;
}

//
- (NSMutableArray *)readSubject1TopicWithType:(topicType)type {
    NSMutableArray *topics = [NSMutableArray array];
    NSString *sql;
    if (type == topicTypeJudgment)
    {
        sql = @"select * from web_note where diff_degree = 4 and Type = 1";
    }
    else
    {
        sql = @"select * from web_note where diff_degree = 1 and Type != 1";
    }
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next) {
        [self dealWithTopics:result andArrar:topics];
    }
    return topics;
}

//
- (NSMutableArray *)readSubject4TopicWithType:(topicType)type {
    NSMutableArray *topics = [NSMutableArray array];
    NSString *sql;
    if (type == topicTypeJudgment) {
        sql = @"SELECT * FROM web_note WHERE kemu = 1 and diff_degree = 4 and LicenseType like '%C1C2C3%'";
    } else {
        sql = @"SELECT * FROM web_note WHERE kemu != 1 and diff_degree = 4 and LicenseType like '%C1C2C3%'";
    }
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next) {
        [self dealWithTopics:result andArrar:topics];
    }
    return topics;
}

- (NSMutableArray *)readSubjectYiCuoTiWithSubject:(NSString *)subject {
    NSString *sql;
    //易错题 选择难度为3的
    NSMutableArray *topics = [NSMutableArray array];
    if ([subject isEqualToString:@"1"])
    {
        sql = @"select * from web_note where kemu = 1 and diff_degree = 5 and LicenseType like '%C1C2C3%'";
        YZLog(@"%@",sql);
    }
    else
    {
        sql = @"select * from web_note where kemu = 4 and diff_degree = 5 and LicenseType like '%C1C2C3%'";
        YZLog(@"%@",sql);
    }
   
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next) {
        [self dealWithTopics:result andArrar:topics];
    }
    return topics;
}

//科一科四未做题
- (NSMutableArray *)readAllWeiZuoTiWithSubject:(NSString *)subject {
    
    NSMutableArray *topics = [NSMutableArray array];
    NSString *sql;
    if ([subject isEqualToString:@"1"])
    {
        sql = @"select * from web_note where kemu = 1 and LicenseType like '%C1C2C3%' and status = 0";
        YZLog(@"%@",sql);
    }
    else
    {
        sql = @"select * from web_note where kemu = 4 and LicenseType like '%C1C2C3%' and status = 0";
        YZLog(@"%@",sql);
    }
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next) {
        [self dealWithTopics:result andArrar:topics];
    }
    return topics;
}

//添加收藏或者错题
- (void)addTopic:(ZXBaseTopicModel *)model saveType:(saveType)type
{
    NSString *sql,*str;
    if (type)
    {
        str = @"web_Fav";
    }
    else
    {
         str = @"web_Error";
    }
    if ([model.sinaimg isKindOfClass:[NSString class]])
    {
        sql = [NSString stringWithFormat:@"insert into %@ values(%@,%@,'%@','%@','%@','%@','%@','%@','%@',%@,'%@',%@,%@)",str,model.ID, model.Type,model.Question,model.An1,model.An2,model.An3,model.An4,model.AnswerTrue,model.explain, model.kemu,model.sinaimg,model.diff_degree,model.status];
    }
    else
    {
        sql = [NSString stringWithFormat:@"insert into %@ values(%@,%@,'%@','%@','%@','%@','%@','%@','%@',%@,'%@',%@,%@)",str,model.ID, model.Type,model.Question,model.An1,model.An2,model.An3,model.An4,model.AnswerTrue,model.explain, model.kemu,@"",model.diff_degree,model.status];
    }
     YZLog(@"%@",sql);
    [_db executeUpdate:sql];
}

- (BOOL)isExist:(saveType)type andContentID:(NSString *)content{
    NSString *sql;
    if (type == saveTypeFav)
    {
        sql =[NSString stringWithFormat:@"select * from web_Fav where ID = %@",content];
    }
    else
    {
        sql =[NSString stringWithFormat:@"select * from web_Error where ID = %@",content];
    }
    FMResultSet *result = [_db executeQuery:sql];
    BOOL isExist = result.next;
    [result close];
    return isExist;
}

//移除题
- (void)removeTopic:(ZXBaseTopicModel *)model saveType:(saveType)type {
    NSString *sql;
    if (type == saveTypeFav)
    {
        
        sql = [NSString stringWithFormat:@"DELETE FROM web_Fav WHERE ID =%@",model.ID];
    }
    else
    {
        
        sql =[NSString stringWithFormat:@"DELETE FROM web_Error WHERE ID =%@",model.ID];
    }
    [_db executeUpdate:sql];
}

- (void)updateTopicStatus:(ZXBaseTopicModel *)model {
    NSString *sql = @"update web_note set status = ? where ID = ?";
    [_db executeUpdate:sql,model.status,model.ID];
}
//重置答题
- (void)resetTopicStatus:(ZXBaseTopicModel *)model{
    NSString *sql = @"update web_note set status = 0 where ID = ?";
    [_db executeUpdate:sql,model.ID];
}

- (void)dealWithTopics:(FMResultSet *)result andArrar:(NSMutableArray *)topicArray{
    //科目
    NSString *  kemu=[result stringForColumn:@"kemu"];
    //题号
    NSString *  ID=[result stringForColumn:@"ID"];
    //题目类型 (判断／单选／多选)
    NSString *  Type=[result stringForColumn:@"Type"];
    //题目
    NSString *  Question=[result stringForColumn:@"Question"];
    //难易程度,
    NSString *  diff_degree=[result stringForColumn:@"diff_degree"];
    //图片或者视频
    NSString *  sinaimg=[result stringForColumn:@"sinaimg"];
    //选项1
    NSString *  An1=[result stringForColumn:@"An1"];
    //选项2
    NSString *  An2=[result stringForColumn:@"An2"];
    //选项3
    NSString *  An3=[result stringForColumn:@"An3"];
    //选项4
    NSString *  An4=[result stringForColumn:@"An4"];
    //所有的答案，可以算出答案的个数
    NSString *  AnswerTrue=[result stringForColumn:@"AnswerTrue"];
    //提示，解析
    NSString *  explain=[result stringForColumn:@"explain"];
    //判断此题是否已经答过
    NSString *  status=[result stringForColumn:@"status"];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                        kemu,@"kemu",
                        ID,@"ID",
                        Type,@"Type",
                        Question,@"Question",
                        AnswerTrue,@"AnswerTrue",
                         nil];
    if (![status isEqualToString:@""])
    {
        [dict setValue:status forKey:@"status"];
    }
    if (![diff_degree isEqualToString:@""])
    {
        [dict setValue:status forKey:@"diff_degree"];
    }

    if (![explain isEqualToString:@""])
    {
        [dict setValue:explain forKey:@"explain"];
    }
    if (![An1 isEqualToString:@""])
    {
        [dict setValue:An1 forKey:@"An1"];
    }
    if (![An2 isEqualToString:@""])
    {
        [dict setValue:An2 forKey:@"An2"];
    }
    if (![An3 isEqualToString:@""])
    {
        [dict setValue:An3 forKey:@"An3"];
    }
    if (![An4 isEqualToString:@""])
    {
        [dict setValue:An4 forKey:@"An4"];
    }
    if (![sinaimg isEqualToString:@""])
    {
        [dict setValue:sinaimg forKey:@"sinaimg"];
    }
    [topicArray addObject:dict];
}




//条件查询
//科一错题
-(NSMutableArray *)readClass1WrongQuestion{
    NSMutableArray *topics = [NSMutableArray array];
    NSString *sql = @"select * from web_note where kemu = 1 and LicenseType like '%C1C2C3%' and status = 2";
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next) {
        [self dealWithTopics:result andArrar:topics];
    }
    return topics;
}
//科一收藏
-(NSMutableArray *)readClass1CollectQuestion{
    NSMutableArray *topics = [NSMutableArray array];
    NSString *sql = @"select * from web_note where kemu = 1 and LicenseType like '%C1C2C3%' and status = 1";
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next) {
        [self dealWithTopics:result andArrar:topics];
    }
    return topics;
}
-(NSMutableArray *)readClass4WrongQuestion{
    NSMutableArray *topics = [NSMutableArray array];
    NSString *sql = @"select * from web_note where kemu = 4 and LicenseType like '%C1C2C3%' and status = 2";
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next) {
        [self dealWithTopics:result andArrar:topics];
    }
    return topics;
}
-(NSMutableArray *)readClass4RightQuestion{
    NSMutableArray *topics = [NSMutableArray array];
    NSString *sql = @"select * from web_note where kemu = 4 and LicenseType like '%C1C2C3%' and status = 1";
    FMResultSet *result = [_db executeQuery:sql];
    while (result.next) {
        [self dealWithTopics:result andArrar:topics];
    }
    return topics;
}











@end

