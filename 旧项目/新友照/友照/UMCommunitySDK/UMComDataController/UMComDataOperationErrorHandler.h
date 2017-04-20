//
//  UMComDataOperationErrorHandler.h
//  UMCommunity
//
//  Created by umeng on 16/7/8.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@class UMComUser;
@class UMComComment;
@class UMComFeed;
@class UMComTopic;

@interface UMComDataOperationErrorHandler : NSObject

+ (void)handelUserErrorWithUser:(UMComUser *)user error:(NSError *)error;

+ (void)handleFeedErrorWithFeed:(UMComFeed *)feed error:(NSError *)error;

+ (void)handleCommentErrorWithComment:(UMComComment *)comment error:(NSError *)error;

+ (void)handleTopicErrorWithTopic:(UMComTopic *)topic error:(NSError *)error;

@end
