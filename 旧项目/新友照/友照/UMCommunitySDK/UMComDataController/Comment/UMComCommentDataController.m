//
//  UMComCommentDataController.m
//  UMCommunity
//
//  Created by umeng on 16/6/28.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComCommentDataController.h"
#import <UMComDataStorage/UMComComment.h>
#import <UMComDataStorage/UMComFeed.h>
#import <UMCommunitySDK/UMComDataRequestManager.h>
#import <UMComNetwork/UMComHttpCode.h>
#import "UMComDataOperationErrorHandler.h"

@implementation UMComCommentDataController

- (instancetype)initWithComment:(UMComComment *)comment
{
    self = [super init];
    if (self) {
        self.comment = comment;
        if (comment.feed) {
            self.feed = comment.feed;
        }else{
            self.feed = [[UMComFeed alloc] init];
            self.feed.feedID = comment.feed_id;
        }
    }
    return self;
}


- (void)deletedCommentCompletion:(UMComCommentOperationCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] commentDeleteWithCommentID:self.comment.commentID feedID:self.feed.feedID completion:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            if ([weakSelf.feed.comments_count intValue] > 0) {
                weakSelf.feed.comments_count = @([weakSelf.feed.comments_count intValue]-1);
            }
            if (completion) {
                completion(weakSelf.comment, nil);
            }
        }else{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [UMComDataOperationErrorHandler handleCommentErrorWithComment:strongSelf.comment error:error];
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)likeCommentCompletion:(UMComCommentOperationCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    BOOL isLike = ![self.comment.liked boolValue];
    [[UMComDataRequestManager defaultManager] commentLikeWithCommentID:self.comment.commentID isLike:isLike completion:^(NSDictionary *responseObject, NSError *error) {
        NSInteger likeCount = [weakSelf.comment.likes_count integerValue];
        if (!error) {
            if (isLike) {
                weakSelf.comment.liked = @1;
                likeCount += 1;
            }else{
                weakSelf.comment.liked = @0;
                likeCount -= 1;
            }
            if (likeCount < 0) {
                likeCount = 0;
            }
            weakSelf.comment.likes_count = @(likeCount);
            if (completion) {
                completion(weakSelf.comment, nil);
            }
        }else{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [UMComDataOperationErrorHandler handleCommentErrorWithComment:strongSelf.comment error:error];
            if (completion) {
                completion(nil, error);
            }
        }
        
    }];
}

- (void)spamCommentCompletion:(UMComCommentOperationCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] commentSpamWithCommentID:self.comment.commentID completion:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            if (completion) {
                completion(weakSelf.comment, nil);
            }
        }else{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [UMComDataOperationErrorHandler handleCommentErrorWithComment:strongSelf.comment error:error];
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}


@end
