//
//  UMComFeedDetailDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/3.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMCommunitySDK/UMComDataRequestManager.h>

@class UMComUser, UMComFeed, UMComComment;

@interface UMComFeedDetailDataController : NSObject

/**
 *Feed
 */
@property (nonatomic, strong) UMComFeed *feed;

/***
 *被回复的用户
 */
//@property (nonatomic, strong) UMComUser *replyUser;

/***
 *当前评论
 */
@property (nonatomic, strong) UMComComment *currentComment;

- (instancetype)initWithFeed:(UMComFeed *)feed viewExtra:(NSDictionary *)viewExtra;

- (void)refreshFeedWithCompletion:(UMComDataRequestCompletion)completion;

- (void)deletedFeedWithCompletion:(UMComDataRequestCompletion)completion;

- (void)likeFeedWithCompletion:(UMComDataRequestCompletion)completion;

- (void)spamFeedWithCompletion:(UMComDataRequestCompletion)completion;

- (void)favoriteFeedWithCompletion:(UMComDataRequestCompletion)completion;

- (void)commentFeedWithContent:(NSString *)content
                        images:(NSArray *)images
                    completion:(UMComDataRequestCompletion)completion;


- (void)replyCommentFeedWithComment:(UMComComment *)comment
                            content:(NSString *)content
                             images:(NSArray *)images
                         completion:(UMComDataRequestCompletion)completion;

- (void)shareToPlatform:(NSString *)platform completion:(UMComDataRequestCompletion)completion;

//- (void)deletedComment:(UMComComment *)comment completion:(UMComDataRequestCompletion)completion;
//
//- (void)likeComment:(UMComComment *)comment completion:(UMComDataRequestCompletion)completion;
//
//- (void)spamComment:(UMComComment *)comment completion:(UMComDataRequestCompletion)completion;

- (void)spamUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion;

- (void)banUser:(UMComUser *)user completion:(UMComDataRequestCompletion)completion;



#pragma mark - check

/**
 *  判断是否为html格式的feed
 *
 *  @return YES htmlFeed NO 普通feed
 */
-(BOOL) isHtmlData;
@end
