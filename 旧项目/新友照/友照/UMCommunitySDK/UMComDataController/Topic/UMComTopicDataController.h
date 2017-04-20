//
//  UMComTopicDataController.h
//  UMCommunity
//
//  Created by umeng on 16/7/1.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMCommunitySDK/UMComDataRequestManager.h>

@class UMComTopic;
@interface UMComTopicDataController : NSObject

@property (nonatomic, strong) UMComTopic *topic;

+ (UMComTopicDataController *)dataControllerWithTopic:(UMComTopic *)topic;

+ (void )getTopicWithTopicId:(NSString *)topicID completion:(UMComDataRequestCompletion)completion;

- (void)followOrDisfollowCompletion:(UMComDataRequestCompletion)completion;


@end
