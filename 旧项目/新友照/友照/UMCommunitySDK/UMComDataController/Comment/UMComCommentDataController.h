//
//  UMComCommentDataController.h
//  UMCommunity
//
//  Created by umeng on 16/6/28.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UMComComment, UMComFeed;

typedef void(^UMComCommentOperationCompletion)(UMComComment *comment, NSError *error);

@interface UMComCommentDataController : NSObject

@property (nonatomic, strong) UMComFeed *feed;

@property (nonatomic, strong) UMComComment *comment;

- (instancetype)initWithComment:(UMComComment *)comment;

- (void)deletedCommentCompletion:(UMComCommentOperationCompletion)completion;

- (void)likeCommentCompletion:(UMComCommentOperationCompletion)completion;

- (void)spamCommentCompletion:(UMComCommentOperationCompletion)completion;


@end
