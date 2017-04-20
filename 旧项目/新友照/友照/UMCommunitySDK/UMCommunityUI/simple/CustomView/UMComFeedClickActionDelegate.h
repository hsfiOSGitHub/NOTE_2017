//
//  UMComFeedClickActionDelegate.h
//  UMCommunity
//
//  Created by umeng on 15/5/22.
//  Copyright (c) 2015年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMComUser, UMComFeed,UMComComment,UMComTopic,UMComLike;
@protocol UMComFeedClickActionDelegate <NSObject>

@optional;

- (void)customObj:(id)obj clickOnFeedCreator:(UMComUser *)user;
- (void)customObj:(id)obj clickOnTopic:(UMComTopic *)topic;
- (void)customObj:(id)obj clickOnFeedText:(UMComFeed *)feed;
- (void)customObj:(id)obj clickOnLikeFeed:(UMComFeed *)feed;
- (void)customObj:(id)obj clickOnCommentFeed:(UMComFeed *)feed;
- (void)customObj:(id)obj clickOnImageView:(UIImageView *)imageView complitionBlock:(void (^)(UIViewController *currentViewController))block;
- (void)customObj:(id)obj clickOnURL:(NSString *)urlSring;

- (void)customObj:(id)obj clickOnOriginFeedText:(UMComFeed *)feed;
- (void)customObj:(id)obj clickOnLocationText:(UMComFeed *)feed;
- (void)customObj:(id)obj clickOnSpamFeed:(UMComFeed *)feed;
- (void)customObj:(id)obj clickOnDeleted:(UMComFeed *)feed;
- (void)customObj:(id)obj clickOnCopyFeed:(UMComFeed *)feed;
- (void)customObj:(id)obj clickOnShare:(UMComFeed *)feed;
- (void)customObj:(id)obj clickOnFavouratesFeed:(UMComFeed *)feed;
- (void)customObj:(id)obj clickOnForward:(UMComFeed *)feed;


@end
