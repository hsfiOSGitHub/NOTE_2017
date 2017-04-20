//
//  UMComCommentListDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/18.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"
#import "UMComResouceDefines.h"

@class UMComFeed;
typedef void(^UMComCommentListOperationCompletion)(NSError *error);

@interface UMComCommentListDataController : UMComListDataController

- (void)deletedComment:(UMComComment *)comment completion:(UMComCommentListOperationCompletion)completion;

- (void)likeComment:(UMComComment *)comment completion:(UMComCommentListOperationCompletion)completion;

- (void)spamComment:(UMComComment *)comment completion:(UMComCommentListOperationCompletion)completion;

- (void)commentFeed:(UMComFeed *)feed
            content:(NSString *)content
             images:(NSArray *)images
         completion:(UMComDataRequestCompletion)completion;


- (void)replyCommentFeed:(UMComFeed *)feed
                 comment:(UMComComment *)comment
                 content:(NSString *)content
                  images:(NSArray *)images
              completion:(UMComDataRequestCompletion)completion;

@end


@interface UMComFeedCommnetListDataController : UMComCommentListDataController

@property (nonatomic, assign)UMComCommentListSortType commentSortType;

@property (nonatomic, copy) NSString *comment_uid;

@property (nonatomic, copy) NSString *feedId;

/**
 获取Feed所有评论的初始化方法
 
 @param count  单页请求评论数量
 @param feedId FeedId
 @param comment_uid	发出评论用户id(用于实现只看楼主)
 @param order: commentorderByTimeDesc时间倒序排列，commentorderByTimeAsc时间正序排列，不传默认为倒序
 
 @returns 获取Feed所有评论请求对象
 */
- (instancetype)initWithCount:(NSInteger)count
                       feedId:(NSString *)feedId
                commentUserId:(NSString *)comment_uid
                        order:(UMComCommentListSortType)orderType;

@end


@interface UMComUserReceivedCommentListDataController : UMComCommentListDataController


- (instancetype)initWithCount:(NSInteger)count;

@end


@interface UMComUserSentCommentListDataController : UMComCommentListDataController

- (instancetype)initWithCount:(NSInteger)count;

@end


