//
//  UMComLikeListDataController.m
//  UMCommunity
//
//  Created by 张军华 on 16/6/24.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComLikeListDataController.h"
#import <UMCommunitySDK/UMComDataRequestManager.h>

@implementation UMComLikeListDataController


@end


@implementation UMComFeedLikeListDataController

- (instancetype)initWithFeedId:(NSString *)feedId count:(NSInteger)count
{
    if (self = [super initWithRequestType:UMComRequestType_FeedLike count:count]) {
        
        self.feedId = feedId;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchLikesFeedWithFeedId:self.feedId count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
    
}

@end


@implementation UMComUserReceivedLikeDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserReceiveLike count:count];
    if (self) {
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself = self;
    [[UMComDataRequestManager defaultManager] fetchLikesUserReceivedWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}

@end
@implementation UMComUserSendLikeDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserReceiveLike count:count];
    if (self) {
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself = self;
    [[UMComDataRequestManager defaultManager] fetchLikesUserSendsWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
}


@end
