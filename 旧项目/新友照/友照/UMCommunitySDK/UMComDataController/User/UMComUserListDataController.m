//
//  UMComUserListDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComUserListDataController.h"
#import <UMComDataStorage/UMComUser.h>
#import <UMComDataStorage/UMComTopic.h>
#import <CoreLocation/CoreLocation.h>
#import <UMCommunitySDK/UMComSession.h>
#import "UMComUserDataController.h"

@interface UMComUserListDataController ()

@property (nonatomic, strong) UMComUserDataController *userDataController;

@end

@implementation UMComUserListDataController

- (void)followOrDisFollowUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion
{
    self.userDataController = [UMComUserDataController userDataControllerWithUser:user];
    [self.userDataController followOrDisFollowUserCompletion:completion];
}


- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    
}

- (void)fetchLocalDataWithCompletion:(UMComDataListRequestCompletion)completion
{
    
}


- (void)fetchDataWithCompletion:(UMComDataListRequestCompletion)localfetchcompletion serverDataCompletion:(UMComDataListRequestCompletion)serverRequestCompletion
{
    
}


@end


/**
 * 用户粉丝列表
 */
@implementation UMComUserFansDataController

+ (UMComUserFansDataController *)userFansDataControllerWithUser:(UMComUser*)user count:(NSInteger)count
{
    UMComUserFansDataController *userDataController = [[UMComUserFansDataController alloc] initWithCount:count];
    userDataController.user = user;
    return userDataController;
}
- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserFansUser count:count];
    if (self) {
        self.pageRequestType = UMComRequestType_UserFansUser;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself = self;
    [[UMComDataRequestManager defaultManager] fetchUserFansWithUid:self.user.uid count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}

-(void)fetchLocalDataWithCompletion:(UMComDataListRequestCompletion)localfetchcompletion
{
    __weak typeof(self) weakSelf = self;
    
    [[UMComDataBaseManager shareManager] fetchASyncRelatedFanUIDWithUID:self.user.uid withCompleteBlock:^(NSArray* userArray, NSError *error) {
        [weakSelf handleLocalData:userArray error:error completion:localfetchcompletion];
    }];
    
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{
    [[UMComDataBaseManager shareManager] saveRelatedFanUIDWithUID:self.user.uid withUsers:dataArray];
}

@end


/**
 *用户关注的人列表
 */
@implementation UMComUserFollowingDataController

+ (UMComUserFollowingDataController *)userFollowingDataControllerWithUser:(UMComUser*)user count:(NSInteger)count
{
    UMComUserFollowingDataController *userDataController = [[UMComUserFollowingDataController alloc] initWithCount:count withUser:user];
    return userDataController;
}
- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithCount:count];
    if (self) {
        self.pageRequestType = UMComRequestType_UserFollowsUser;
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count withUser:(UMComUser*)user
{
    if (self = [self initWithCount:count]) {
        self.user = user;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself = self;
    [[UMComDataRequestManager defaultManager] fetchUserFollowingsWithUid:self.user.uid count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}

-(void)fetchLocalDataWithCompletion:(UMComDataListRequestCompletion)localfetchcompletion
{
    __weak typeof(self) weakSelf = self;
    
    [[UMComDataBaseManager shareManager] fetchASyncRelatedFollowerUIDWithUID:self.user.uid withCompleteBlock:^(NSArray* userArray, NSError *error) {
        [weakSelf handleLocalData:userArray error:error completion:localfetchcompletion];
    }];
    
}

-(void)saveLocalDataWithDataArray:(NSArray*)dataArray
{
    [[UMComDataBaseManager shareManager] saveRelatedFollowerUIDWithUID:self.user.uid withUsers:dataArray];
}

@end

/**
 *推荐用户列表
 */
@implementation UMComUserRecommendDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageRequestType = UMComRequestType_RecommentUser;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself = self;
    [[UMComDataRequestManager defaultManager] fetchUsersRecommentWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
         [weakself handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *话题下活跃用户
 */
@implementation UMComUserTopicHotDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageRequestType = UMComRequestType_UserFansUser;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchUsersWithActiveTopicId:self.topic.topicID count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end

/**
 *附近用户
 */
@implementation UMComUserNearbyDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageRequestType = UMComRequestType_UserFansUser;
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count location:(CLLocation*)location
{
    self = [super initWithRequestType:UMComRequestType_UserFansUser count:count];
    if (self) {
        self.location = location;
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself = self;
    [[UMComDataRequestManager defaultManager] fetchUserNearbyWithLocation:self.location count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}

@end

@implementation UMComSearchUserListDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pageRequestType = UMComRequestType_SearchFriendListUser;
    }
    return self;
}

- (instancetype)initWithCount:(NSInteger)count keyWord:(NSString*)keyWord
{
    self = [super initWithRequestType:UMComRequestType_SearchFriendListUser count:count];
    if (self) {
        self.keyWord = keyWord;
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself = self;
    [[UMComDataRequestManager defaultManager] fetchUsersFromSearchWithKeywords:self.keyWord count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
    
}
@end
