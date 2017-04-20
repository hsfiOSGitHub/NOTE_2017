//
//  UMComUserDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComUserDataController.h"
#import <UMCommunitySDK/UMComDataRequestManager.h>
#import <UMCommunitySDK/UMComDataTypeDefine.h>
#import <UMComDataStorage/UMComUser.h>
#import "UMComUserOperationFinishDelegate.h"
#import <UMComNetwork/UMComHttpCode.h>
#import <UMCommunitySDK/UMComSession.h>
#import "UMComDataOperationErrorHandler.h"

@implementation UMComUserDataController

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

+ (UMComUserDataController *)userDataControllerWithUser:(UMComUser *)user
{
    UMComUserDataController *userDataController = [[UMComUserDataController alloc] init];
    userDataController.user = user;
    return userDataController;
}

+ (void)getUserWithUserID:(NSString *)userID completion:(UMComDataRequestCompletion)completion
{
    UMComUser* user = [UMComUser objectWithObjectId:userID];
    if (user && completion) {
        completion(user,nil);
    }
    else{
        UMComUser* user = [[UMComUser alloc] init];
        user.uid = userID;
        UMComUserDataController *userDataController = [UMComUserDataController userDataControllerWithUser:user];
        [userDataController fetchUserProfileCompletion:completion];
    }
}

- (void)fetchUserProfileCompletion:(UMComDataRequestCompletion)completion;
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchUserProfileWithUid:self.user.uid source:nil source_uid:nil completion:^(NSDictionary *responseObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleResponseData:responseObject error:error];        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            UMComUser *currentUser = [responseObject valueForKey:UMComModelDataKey];
            if (completion) {
                completion(currentUser, nil);
            }
        }else{
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

/**
 *关注或取消关注用户
 */
- (void)followOrDisFollowUserCompletion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    BOOL isFollow = !(self.user.relation.integerValue == 1 || self.user.relation.integerValue == 3);
    [[UMComDataRequestManager defaultManager] userFollowWithUserID:self.user.uid isFollow:isFollow completion:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            UMComUser *loginUser = [UMComSession sharedInstance].loginUser;
            NSInteger loginUserFollowCount = loginUser.following_count.integerValue;
            NSInteger currentUserFansCount = weakSelf.user.fans_count.integerValue;
            if (isFollow) {
                loginUser.following_count = @(loginUserFollowCount + 1);
                currentUserFansCount += 1;
            }else{
                if (loginUserFollowCount > 0) {
                   loginUser.following_count = @(loginUserFollowCount - 1);
                }
                if (currentUserFansCount > 0) {
                    currentUserFansCount -= 1;
                }
            }
            weakSelf.user.fans_count = @(currentUserFansCount);
        }else{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf handleResponseData:responseObject error:error];
        }
        if (completion) {
            completion(weakSelf.user, error);
        }
    }];
}

/**
 * 举报用户
 */
- (void)spamUserCompletion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] userSpamWitUID:self.user.uid completion:^(NSDictionary *responseObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleResponseData:responseObject error:error];
        if (completion) {
            completion(responseObject, error);
        }
    }];
}

- (void)banUserWithTopics:(NSArray *)topics completion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] userBanWithUserId:self.user.uid inTopicIDs:[topics valueForKeyPath:@"topicID"] ban:YES completion:^(NSDictionary *responseObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleResponseData:responseObject error:error];
        if (completion) {
            completion(responseObject, error);
        }
    }];
}


- (void)creatChartBoxWithCompletion:(UMComDataRequestCompletion __nullable)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] getChartBoxWithUid:self.user.uid completion:^(NSDictionary *responseObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf handleResponseData:responseObject error:error];
        if (!error) {
            UMComPrivateLetter *privateLetter = [responseObject valueForKey:UMComModelDataKey];
            if (completion) {
                completion(privateLetter, error);
            }
        }else{
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)sendUserPrivateMessage:(NSString *)content completion:(UMComDataRequestCompletion __nullable)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] privateMessageSendWithContent:content toUid:self.user.uid completion:^(NSDictionary *responseObject, NSError *error) {
        UMComPrivateMessage *privateMessage = nil;
        if (error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf handleResponseData:responseObject error:error];
        }else{
            privateMessage = [responseObject valueForKey:UMComModelDataKey];;
        }
        if (completion) {
             completion(privateMessage, error);
        }
    }];
}


- (void)handleResponseData:(NSDictionary *)responseDict error:(NSError *)error
{
    if (error) {
        [UMComDataOperationErrorHandler handelUserErrorWithUser:self.user error:error];
    }
}

@end
