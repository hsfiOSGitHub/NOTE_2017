//
//  UMComTopicListDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/5.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComTopicListDataController.h"
#import "UMComResouceDefines.h"
#import <UMComDataStorage/UMComTopic.h>
#import <UMCommunitySDK/UMComDataTypeDefine.h>
#import <UMComNetwork/UMComHttpCode.h>
#import "UMComTopicDataController.h"



@interface UMComTopicListDataController ()

@property (nonatomic, strong) UMComTopicDataController *topicDataController;

-(void)handleResponse:(NSDictionary*)responseObject withError:(NSError*)error withRequestCompletion:(UMComDataListRequestCompletion)completion;
@end

@implementation UMComTopicListDataController



- (void)followOrDisfollowTopic:(UMComTopic *)topic completion:(UMComDataRequestCompletion)completion
{
    self.topicDataController = [UMComTopicDataController dataControllerWithTopic:topic];
    [self.topicDataController followOrDisfollowCompletion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(topic, error);
        }
    }];
}


-(void)handleResponse:(NSDictionary*)responseObject withError:(NSError*)error withRequestCompletion:(UMComDataListRequestCompletion)completion
{
    if (error)
    {
        completion(nil,error);
    }
    else
    {
        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
            self.nextPageUrl = [responseObject valueForKey:UMComModelDataNextPageUrlKey];
            NSNumber* visit =  [responseObject valueForKey:UMComModelDataVisitKey];
            if(visit.integerValue == 0){
                self.canVisitNextPage = NO;
            }
            else if(visit.integerValue == 1){
                self.canVisitNextPage = YES;
            }
            else{
                self.canVisitNextPage = YES;
            }
            
            NSArray* topicArray = [responseObject valueForKey:UMComModelDataKey];
            if (topicArray && [topicArray isKindOfClass:[NSArray class]]) {
                self.dataArray = [NSMutableArray arrayWithArray:topicArray];
                if (completion) {
                    completion(self.dataArray,nil);
                }
                
            }
            else{
                if (completion) {
                    completion(nil,error);
                }
            }
        }
    }
}

@end


/**
 *全部话题列表
 */
@implementation UMComTopicsAllDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_AllTopic count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager] fetchTopicsAllWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}


@end

/**
 *推荐话题列表
 */
@implementation UMComTopicsRecommendDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_RecommendTopic count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{

    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager] fetchTopicsRecommendWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *我关注的话题列表
 */
@implementation UMComTopicsFocusDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_FocusedTopic count:count];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count withUID:(NSString*)uid
{
    self = [self initWithCount:count];
    if (self) {
        self.uid = uid;
    }
    
    return self;
}


- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager] fetchTopicsUserFocusWithUid:self.uid count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}

-(void)fetchLocalDataWithCompletion:(UMComDataListRequestCompletion)localfetchcompletion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataBaseManager shareManager] fetchASyncRelatedTopicIDWithUID:self.uid withCompleteBlock:^(NSArray* dataArray, NSError * error) {
        [weakSelf handleLocalData:dataArray error:error completion:localfetchcompletion];
    }];
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{
    [[UMComDataBaseManager shareManager] saveRelatedTopicIDWithUID:self.uid withTopics:dataArray];
}

@end


/**
 *搜索话题
 */
@implementation UMComTopicsSearchDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_FocusedTopic count:count];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count withKeyWord:(NSString *)keyWord
{
    self = [super initWithCount:count];
    if (self) {
        self.keyWord = keyWord;
    }
    
    return self;
}


- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager] fetchTopicsSearchWithKeywords:self.keyWord count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
        //[weakself handleResponse:responseObject withError:error withRequestCompletion:completion];
    }];
}

@end

/**
 *话题组下的话题列表
 */
@implementation UMComGroupTopicDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_GroupsTopic count:count];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count withGroupID:(NSString*)groupID
{
    self = [super initWithCount:count];
    if (self) {
        self.groupID = groupID;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{

    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager] fetchTopicsWithTopicGroupID:self.groupID count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}

@end


