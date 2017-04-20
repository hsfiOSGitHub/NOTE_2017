//
//  UMComFeedDetailDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/3.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFeedDetailDataController.h"
#import "UMComUserDataController.h"
#import <UMComDataStorage/UMComUser.h>
#import <UMComDataStorage/UMComFeed.h>
#import <UMComDataStorage/UMComComment.h>
#import <UMCommunitySDK/UMComSession.h>
#import <UMCommunitySDK/UMComDataTypeDefine.h>
#import <UMComNetwork/UMComHttpCode.h>
#import "UMComDataOperationErrorHandler.h"
#import "UMComNotificationMacro.h"

@interface UMComFeedDetailDataController ()

@property (nonatomic, strong) UMComUserDataController *userDatController;

@end

@implementation UMComFeedDetailDataController

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (instancetype)initWithFeed:(UMComFeed *)feed viewExtra:(NSDictionary *)viewExtra
{
    self = [super init];
    if (self) {
        self.feed = feed;
    }
    return self;
}

+ (void)getFeedWithFeedID:(NSString *)feedID completion:(UMComDataRequestCompletion)completion
{
    UMComFeed *feed = [UMComFeed objectWithObjectId:feedID];
    if (feed && completion) {
        completion(feed, nil);
    }else{
        feed = [[UMComFeed alloc] init];
        feed.feedID = feedID;
        UMComFeedDetailDataController *feedDataController = [[UMComFeedDetailDataController alloc] initWithFeed:feed viewExtra:nil];
        [feedDataController refreshFeedWithCompletion:completion];
    }
}


- (void)refreshFeedWithCompletion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    
    [[UMComDataRequestManager defaultManager] fetchFeedWithFeedId:self.feed.feedID commentId:nil completion:^(NSDictionary *responseObject, NSError *error) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject valueForKey:UMComModelDataKey]) {
            UMComFeed *feed = [responseObject valueForKey:UMComModelDataKey];
            weakSelf.feed = feed;
            if (completion) {
                completion(feed, nil);
            }
        }else{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [UMComDataOperationErrorHandler handleFeedErrorWithFeed:strongSelf.feed error:error];
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}


- (void)deletedFeedWithCompletion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] feedDeleteWithFeedID:self.feed.feedID completion:^(NSDictionary *responseObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!error) {
            UMComUser *loginUser = [UMComSession sharedInstance].loginUser;
            if ([loginUser.uid isEqualToString:weakSelf.feed.creator.uid]) {
                loginUser.feed_count = @(loginUser.feed_count.integerValue-1);
            }
            weakSelf.feed.status = @3;
            if (completion) {
                completion([responseObject valueForKey:UMComModelDataKey], nil);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kUMComFeedDeletedFinishNotification object:strongSelf.feed];
        }else{
            [UMComDataOperationErrorHandler handleFeedErrorWithFeed:strongSelf.feed error:error];
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)likeFeedWithCompletion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    BOOL isLike = ![self.feed.liked boolValue];
    [[UMComDataRequestManager defaultManager] feedLikeWithFeedID:self.feed.feedID isLike:isLike completion:^(NSDictionary *responseObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (!error) {
            NSDictionary* dic =  (NSDictionary*)responseObject;
            if (dic && [dic isKindOfClass:[NSDictionary class]]) {
                
                id feedLikeValue =  [dic valueForKey:UMComModelFeedLikeKey];
                if (feedLikeValue && [feedLikeValue isKindOfClass:[NSNumber class]]) {
                    
                    strongSelf.feed.liked = feedLikeValue;
                    if (strongSelf.feed.liked.boolValue) {
                        strongSelf.feed.likes_count = @(strongSelf.feed.likes_count.integerValue + 1);
                    }
                    else{
                        strongSelf.feed.likes_count = @(strongSelf.feed.likes_count.integerValue - 1);
                    }
                    
                    if (completion) {
                        completion(responseObject, error);
                    }
                }
            }
        }else{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [UMComDataOperationErrorHandler handleFeedErrorWithFeed:strongSelf.feed error:error];
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)spamFeedWithCompletion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] feedSpamWithFeedID:self.feed.feedID completion:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            if (completion) {
                completion(responseObject, nil);
            }
        }else{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [UMComDataOperationErrorHandler handleFeedErrorWithFeed:strongSelf.feed error:error];
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)favoriteFeedWithCompletion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    BOOL isFavorite = ![self.feed.has_collected boolValue];
    [[UMComDataRequestManager defaultManager] feedFavouriteWithFeedId:self.feed.feedID isFavourite:isFavorite completionBlock:^(NSDictionary *responseObject, NSError *error) {

        if (!error) {
            if (isFavorite == YES) {
                weakSelf.feed.has_collected = @1;
            }else{
                weakSelf.feed.has_collected = @0;
            }
            if (completion) {
                completion(responseObject, error);
            }
        }else{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [UMComDataOperationErrorHandler handleFeedErrorWithFeed:strongSelf.feed error:error];
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)commentFeedWithContent:(NSString *)content
                        images:(NSArray *)images
                    completion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] commentFeedWithFeedID:self.feed.feedID commentContent:content replyCommentID:nil replyUserID:nil commentCustomContent:nil images:images completion:^(NSDictionary *responseObject, NSError *error) {
        if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject valueForKey:UMComModelDataKey]) {
                weakSelf.feed.comments_count = @([weakSelf.feed.comments_count intValue]+1);
            
            //获得评论数，对likes_count判断
            UMComComment *comment = [responseObject valueForKey:UMComModelDataKey];
            if ([comment isKindOfClass:[UMComComment class]] && ![comment.likes_count isKindOfClass:[NSNumber class]]) {
                //如果服务器没有发送这个字段就把likes_count的置为0
                comment.likes_count = @0;
            }
            
            if (completion) {

                completion(comment, nil);
            }
        }
        else{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [UMComDataOperationErrorHandler handleFeedErrorWithFeed:strongSelf.feed error:error];
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)replyCommentFeedWithComment:(UMComComment *)comment
                            content:(NSString *)content
                             images:(NSArray *)images
                         completion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] commentFeedWithFeedID:self.feed.feedID commentContent:content replyCommentID:comment.commentID replyUserID:comment.creator.uid commentCustomContent:nil images:images completion:^(NSDictionary *responseObject, NSError *error) {
        weakSelf.currentComment = nil;
        if (!error) {
            UMComComment *newComment = nil;
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                newComment = [responseObject valueForKey:UMComModelDataKey];
                weakSelf.feed.comments_count = @([weakSelf.feed.comments_count intValue]+1);
                
                //获得评论数，对likes_count判断
                if ([newComment isKindOfClass:[UMComComment class]] && ![newComment.likes_count isKindOfClass:[NSNumber class]]) {
                    //如果服务器没有发送这个字段就把likes_count的置为0
                    newComment.likes_count = @0;
                }
                
                if (completion) {
                    completion(newComment, nil);
                }
            }
        }else{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [UMComDataOperationErrorHandler handleFeedErrorWithFeed:strongSelf.feed error:error];
            if (completion) {
                completion(nil, error);
            }
        }
    }];
}

- (void)shareToPlatform:(NSString *)platform completion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] feedShareToPlatform:platform feedId:self.feed.feedID completion:^(NSDictionary *responseObject, NSError *error) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSInteger shareCount = [strongSelf.feed.share_count integerValue];
        if (!error) {
            shareCount +=1;
        }
        strongSelf.feed.share_count = @(shareCount);
        [UMComDataOperationErrorHandler handleFeedErrorWithFeed:strongSelf.feed error:error];
        if (completion) {
            completion(responseObject, error);
        }
    }];
}

//
//- (void)deletedComment:(UMComComment *)comment completion:(UMComDataRequestCompletion)completion
//{
//    __weak typeof(self) weakSelf = self;
//    [[UMComDataRequestManager defaultManager] commentDeleteWithCommentID:comment.commentID feedID:self.feed.feedID completion:^(NSDictionary *responseObject, NSError *error) {
//        if (!error) {
//            if ([weakSelf.feed.comments_count intValue] > 0) {
//                weakSelf.feed.comments_count = @([weakSelf.feed.comments_count intValue]-1);
//            }
//            if (completion) {
//                completion(responseObject, nil);
//            }
//        }else{
//            if (completion) {
//                completion(nil, error);
//            }
//        }
//    }];
//}
//
//- (void)likeComment:(UMComComment *)comment completion:(UMComDataRequestCompletion)completion
//{
//    BOOL isLike = ![comment.liked boolValue];
//    [[UMComDataRequestManager defaultManager] commentLikeWithCommentID:comment.commentID isLike:isLike completion:^(NSDictionary *responseObject, NSError *error) {
//        NSInteger likeCount = [comment.likes_count integerValue];
//        if (!error) {
//            if (isLike) {
//                comment.liked = @1;
//                likeCount += 1;
//            }else{
//                comment.liked = @0;
//                likeCount -= 1;
//            }
//            if (likeCount < 0) {
//                likeCount = 0;
//            }
//            comment.likes_count = @(likeCount);
//            if (completion) {
//                completion(responseObject, nil);
//            }
//        }else{
//            if (error.code == ERR_CODE_FEED_HAS_BEEN_LIKED) {
//                comment.liked = @1;
//                likeCount += 1;
//            }else if (error.code == ERR_CODE_LIKE_HAS_BEEN_CANCELED){
//                comment.liked = @0;
//                likeCount -= 1;
//            }
//            if (likeCount < 0) {
//                likeCount = 0;
//            }
//            comment.likes_count = @(likeCount);
//            if (completion) {
//                completion(nil, error);
//            }
//        }
//
//    }];
//}
//
//- (void)spamComment:(UMComComment *)comment completion:(UMComDataRequestCompletion)completion
//{
//    [[UMComDataRequestManager defaultManager] commentSpamWithCommentID:comment.commentID completion:^(NSDictionary *responseObject, NSError *error) {
//        if (!error) {
//            if (completion) {
//                completion(responseObject, nil);
//            }
//        }else{
//            if (completion) {
//                completion(nil, error);
//            }
//        }
//    }];
//}

- (void)spamUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion
{
    self.userDatController = [UMComUserDataController userDataControllerWithUser:user];
    [self.userDatController spamUserCompletion:completion];
}


- (void)banUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion
{
    self.userDatController = [UMComUserDataController userDataControllerWithUser:user];
    [self.userDatController banUserWithTopics:self.feed.topics completion:completion];
}

#pragma mark - check
/**
 *  判断是否为html格式的feed
 *
 *  @return YES htmlFeed NO 普通feed
 */
-(BOOL) isHtmlData
{
    if (self.feed.media_type.intValue == 1 &&  self.feed.rich_text && self.feed.rich_text.length > 0) {
        return YES;
    }
    return NO;
}



@end
