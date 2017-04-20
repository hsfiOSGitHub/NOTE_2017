//
//  UMComFeedOperationFinshDelegate.h
//  UMCommunity
//
//  Created by umeng on 16/1/13.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMComFeed, UMComComment;

@protocol UMComSimpleFeedOperationFinishDelegate <NSObject>

@optional;

- (void)feedCreatedSucceedWithFeed:(UMComFeed *)feed;

- (void)feedDeletedWithFeed:(UMComFeed *)feed;
//
- (void)feedCommentDeletedWithComment:(UMComComment *)comment feed:(UMComFeed *)feed;

- (void)feedCommentSendSucceedWithComment:(UMComComment *)comment feed:(UMComFeed *)feed;

- (void)feedLikeStatusChangeWithFeed:(UMComFeed *)feed;

- (void)feedFavourateStatusChangeWithFeed:(UMComFeed *)feed;

/**
 *  点赞的回调
 *
 *  @param feed       当前点赞的feed
 *  @param targetCell 需要刷新的cell
 */
//-(void)feedLikeChanged:(UMComFeed*)feed toTargetCell:(id)targetCell;
@end
