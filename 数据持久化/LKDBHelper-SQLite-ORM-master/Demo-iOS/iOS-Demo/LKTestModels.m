//
//  LKTestModels.m
//  LKDBHelper
//
//  Created by upin on 13-7-12.
//  Copyright (c) 2013年 ljh. All rights reserved.
//

#import "LKTestModels.h"

@implementation LKTest

//重载选择 使用的LKDBHelper
+(LKDBHelper *)getUsingLKDBHelper
{
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
//        NSString* dbpath = [NSHomeDirectory() stringByAppendingPathComponent:@"asd/asd.db"];
//        db = [[LKDBHelper alloc]initWithDBPath:dbpath];
        //or
                db = [[LKDBHelper alloc]init];
    });
    return db;
}

//在类 初始化的时候
+(void)initialize
{
    //remove unwant property
    //比如 getTableMapping 返回nil 的时候   会取全部属性  这时候 就可以 用这个方法  移除掉 不要的属性
    [self removePropertyWithColumnName:@"error"];
    
    
    //simple set a column as "LKSQL_Mapping_UserCalculate"
    //根据 属性名  来启用自己计算
    //[self setUserCalculateForCN:@"error"];
    
    
    //根据 属性类型  来启用自己计算
    //[self setUserCalculateForPTN:@"NSDictionary"];
    
    //enable own calculations
    //[self setUserCalculateForCN:@"address"];
    
    //enable the column binding property name
    [self setTableColumnName:@"MyAge" bindingPropertyName:@"age"];
    [self setTableColumnName:@"MyDate" bindingPropertyName:@"date"];
}

+(void)dbDidAlterTable:(LKDBHelper *)helper tableName:(NSString *)tableName addColumns:(NSArray *)columns
{
    for (int i=0; i<columns.count; i++)
    {
        LKDBProperty* p = [columns objectAtIndex:i];
        if([p.propertyName isEqualToString:@"error"])
        {
            [helper executeDB:^(FMDatabase *db) {
                NSString* sql = [NSString stringWithFormat:@"update %@ set error = name",tableName];
                [db executeUpdate:sql];
            }];
        }
    }
    LKErrorLog(@"your know %@",columns);
}

// 将要插入数据库
+(BOOL)dbWillInsert:(NSObject *)entity
{
    LKErrorLog(@"will insert : %@",NSStringFromClass(self));
    return YES;
}
//已经插入数据库
+(void)dbDidInserted:(NSObject *)entity result:(BOOL)result
{
    LKErrorLog(@"did insert : %@",NSStringFromClass(self));
}

// 重载    返回自己处理过的 要插入数据库的值
-(id)userGetValueForModel:(LKDBProperty *)property
{
    if([property.sqlColumnName isEqualToString:@"address"])
    {
        if(self.address == nil)
            return @"";
        [LKTestForeign insertToDB:self.address];
        return @(self.address.addid);
    }
    return nil;
}
// 重载    从数据库中  获取的值   经过自己处理 再保存
-(void)userSetValueForModel:(LKDBProperty *)property value:(id)value
{
    if([property.sqlColumnName isEqualToString:@"address"])
    {
        self.address = nil;
        
        NSMutableArray* array  = [LKTestForeign searchWithWhere:[NSString stringWithFormat:@"addid = %d",[value intValue]] orderBy:nil offset:0 count:1];
        
        if(array.count>0)
            self.address = [array objectAtIndex:0];
    }
}

//列属性
+(void)columnAttributeWithProperty:(LKDBProperty *)property
{
    if([property.sqlColumnName isEqualToString:@"MyAge"])
    {
        property.defaultValue = @"15";
    }
    else if([property.propertyName isEqualToString:@"date"])
    {
        // if you use unique,this property will also become the primary key
//        property.isUnique = YES;
        property.checkValue = @"MyDate > '2000-01-01 00:00:00'";
        property.length = 30;
    }
}

//手动or自动 绑定sql列
+(NSDictionary *)getTableMapping
{
    return nil;
//    return @{@"name":LKSQL_Mapping_Inherit,
//             @"MyAge":@"age",
//             @"img":LKSQL_Mapping_Inherit,
//             @"MyDate":@"date",
//             
//             // version 2 after add
//             @"color":LKSQL_Mapping_Inherit,
//             
//             //version 3 after add
//             @"address":LKSQL_Mapping_UserCalculate,
//             @"error":LKSQL_Mapping_Inherit
//             };
}
//主键
+(NSString *)getPrimaryKey
{
    return @"name";
}
///复合主键  这个优先级最高
+(NSArray *)getPrimaryKeyUnionArray
{
    return @[@"name",@"MyAge"];
}
//表名
+(NSString *)getTableName
{
    return @"LKTestTable";
}
@end
@implementation LKTestForeign
+(LKDBHelper *)getUsingLKDBHelper
{
    return [LKTest getUsingLKDBHelper];
}
+(NSString *)getPrimaryKey
{
    return @"addid";
}
+(NSString *)getTableName
{
    return @"LKTestAddress";
}
+(BOOL)isContainParent
{
    return YES;
}
@end

@implementation LKTestForeignSuper
@end




@implementation NSObject(PrintSQL)

+(NSString *)getCreateTableSQL
{
    LKModelInfos* infos = [self getModelInfos];
    NSString* primaryKey = [self getPrimaryKey];
    NSMutableString* table_pars = [NSMutableString string];
    for (int i=0; i<infos.count; i++) {
        
        if(i > 0)
            [table_pars appendString:@","];
        
        LKDBProperty* property =  [infos objectWithIndex:i];
        [self columnAttributeWithProperty:property];
        
        [table_pars appendFormat:@"%@ %@",property.sqlColumnName,property.sqlColumnType];
        
        if([property.sqlColumnType isEqualToString:LKSQL_Type_Text])
        {
            if(property.length>0)
            {
                [table_pars appendFormat:@"(%ld)",(long)property.length];
            }
        }
        if(property.isNotNull)
        {
            [table_pars appendFormat:@" %@",LKSQL_Attribute_NotNull];
        }
        if(property.isUnique)
        {
            [table_pars appendFormat:@" %@",LKSQL_Attribute_Unique];
        }
        if(property.checkValue)
        {
            [table_pars appendFormat:@" %@(%@)",LKSQL_Attribute_Check,property.checkValue];
        }
        if(property.defaultValue)
        {
            [table_pars appendFormat:@" %@ %@",LKSQL_Attribute_Default,property.defaultValue];
        }
        if(primaryKey && [property.sqlColumnName isEqualToString:primaryKey])
        {
            [table_pars appendFormat:@" %@",LKSQL_Attribute_PrimaryKey];
        }
    }
    NSString* createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",[self getTableName],table_pars];
    return createTableSQL;
}

@end