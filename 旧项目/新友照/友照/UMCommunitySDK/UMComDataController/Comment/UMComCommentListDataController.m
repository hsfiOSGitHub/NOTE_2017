//
//  UMComCommentListDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComCommentListDataController.h"
#import "UMComCommentDataController.h"
#import "UMComFeedDetailDataController.h"
#import <UMComNetwork/UMComHttpCode.h>

@interface UMComCommentListDataController ()

@property (nonatomic, strong) UMComCommentDataController *commentDataController;

@property (nonatomic, strong) UMComFeedDetailDataController *feedDetailDataController;

- (void)handleCommentData:(NSDictionary *)data error:(NSError *)error completion:(UMComDataListRequestCompletion)completion;

@end

@implementation UMComCommentListDataController


- (void)deletedComment:(UMComComment *)comment completion:(UMComCommentListOperationCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    self.commentDataController = [[UMComCommentDataController alloc] initWithComment:comment];
    [self.commentDataController deletedCommentCompletion:^(UMComComment *returnComment, NSError *error) {
        if (error) {
            [weakSelf handleComment:comment error:error];
        }else{
            if ([weakSelf.dataArray containsObject:comment]) {
                [weakSelf.dataArray removeObject:comment];
            }
        }
        if (completion) {
            completion(error);
        }
    }];
}

- (void)likeComment:(UMComComment *)comment completion:(UMComCommentListOperationCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    self.commentDataController = [[UMComCommentDataController alloc] initWithComment:comment];
    [self.commentDataController likeCommentCompletion:^(UMComComment *comment, NSError *error) {
        [weakSelf handleComment:comment error:error];
        if (completion) {
            completion(error);
        }
    }];
}

- (void)spamComment:(UMComComment *)comment completion:(UMComCommentListOperationCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    self.commentDataController = [[UMComCommentDataController alloc] initWithComment:comment];
    [self.commentDataController spamCommentCompletion:^(UMComComment *comment, NSError *error) {
        [weakSelf handleComment:comment error:error];
        if (completion) {
            completion(error);
        }
    }];
}

- (void)handleComment:(UMComComment *)comment error:(NSError *)error
{
    if (error.code == ERR_CODE_FEED_COMMENT_UNAVAILABLE) {
        if (![self.dataArray containsObject:comment]) {
            [self.dataArray removeObject:comment];
        }
    }
}

- (void)commentFeed:(UMComFeed *)feed
            content:(NSString *)content
             images:(NSArray *)images
         completion:(UMComDataRequestCompletion)completion
{
    self.feedDetailDataController = [[UMComFeedDetailDataController alloc] initWithFeed:feed viewExtra:nil];
    [self.feedDetailDataController commentFeedWithContent:content images:images completion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(responseObject, error);
        }
    }];
}


- (void)replyCommentFeed:(UMComFeed *)feed
                 comment:(UMComComment *)comment
                 content:(NSString *)content
                  images:(NSArray *)images
              completion:(UMComDataRequestCompletion)completion
{
    self.feedDetailDataController = [[UMComFeedDetailDataController alloc] initWithFeed:feed viewExtra:nil];
    [self.feedDetailDataController replyCommentFeedWithComment:comment content:content images:images completion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(responseObject, error);
        }
    }];
}


- (void)handleCommentData:(NSDictionary *)data error:(NSError *)error completion:(UMComDataListRequestCompletion)completion
{
    [self handleNewData:data error:error completion:completion];
}

@end


@implementation UMComFeedCommnetListDataController

- (instancetype)initWithCount:(NSInteger)count
                       feedId:(NSString *)feedId
                commentUserId:(NSString *)comment_uid
                        order:(UMComCommentListSortType)orderType
{
    self = [super initWithRequestType:UMComRequestType_FeedComment count:count];
    if (self) {
        self.feedId = feedId;
        self.comment_uid = comment_uid;
        self.commentSortType = orderType;
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchCommentsWithFeedId:self.feedId commentUserId:self.comment_uid sortType:self.commentSortType count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleCommentData:responseObject error:error completion:completion];
    }];
}

@end
@implementation UMComUserReceivedCommentListDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserReceiveComment count:count];
    if (self) {
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchCommentsUserReceivedWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleCommentData:responseObject error:error completion:completion];
    }];
}

@end
@implementation UMComUserSentCommentListDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_UserSendComment count:count];
    if (self) {
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchCommentsUserSentWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleCommentData:responseObject error:error completion:completion];
    }];
}

@end


