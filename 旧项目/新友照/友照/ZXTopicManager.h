//
//  ZXTopicManager.h
//  ZXJiaXiao
//
//  Created by ZX on 16/2/26.
//  Copyright © 2016年 ZX. All rights reserved.
//数据库

#import <Foundation/Foundation.h>
#import "ZXBaseTopicModel.h"

typedef NS_ENUM(NSInteger, saveType) {
    saveTypeWrong = 0,
    saveTypeFav = 1
};
typedef NS_ENUM(NSInteger, topicType)
{
    //1是判断，2是选择，多选的话需要从选择里面再单独判断
    topicTypeSingle = 1,
    topicTypeJudgment = 2,

};
@interface ZXTopicManager : NSObject
//数据库单利
+ (instancetype)sharedTopicManager;
//读数据
- (NSMutableArray *)readAllSubject1Topics;
- (NSMutableArray *)readAllSubject4Topics;

//读取所有科一收藏的题
- (NSMutableArray *)readClass1AllFavTopics;
//读取所有科四收藏的题
- (NSMutableArray *)readClass4AllFavTopics;
//读取所有科一的错题
- (NSMutableArray *)readClass1AllWrongTopics;
//读取所有科四的错题
- (NSMutableArray *)readClass4AllWrongTopics; 

- (NSMutableArray *)readSubject1TopicWithType:(topicType)type;
- (NSMutableArray *)readSubject4TopicWithType:(topicType)type;

- (NSMutableArray *)readSubjectYiCuoTiWithSubject:(NSString *)subject;
- (NSMutableArray *)readAllWeiZuoTiWithSubject:(NSString *)subject;

//读取所有科四专项的试题
- (NSMutableArray *)readAllSubject4Topics:(NSString*)Type;
//读取所有科一专项的试题
- (NSMutableArray *)readAllSubject1Topics:(NSString*)Type;

//查询是否存在
- (BOOL)isExist:(saveType)type andContentID:(NSString *)content;


//写数据（错题 收藏的题目）
- (void)addTopic:(ZXBaseTopicModel *)model saveType:(saveType)type;

- (void)removeTopic:(ZXBaseTopicModel *)model saveType:(saveType)type;




//更新数据
- (void)updateTopicStatus:(ZXBaseTopicModel *)model;
//重置答题
- (void)resetTopicStatus:(ZXBaseTopicModel *)model;

@end
