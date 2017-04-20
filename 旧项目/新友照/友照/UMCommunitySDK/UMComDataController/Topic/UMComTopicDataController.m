//
//  UMComTopicDataController.m
//  UMCommunity
//
//  Created by umeng on 16/7/1.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComTopicDataController.h"
#import <UMComDataStorage/UMComTopic.h>
#import <UMComNetwork/UMComHttpCode.h>
#import "UMComDataOperationErrorHandler.h"
#import <UMCommunitySDK/UMComDataTypeDefine.h>

@implementation UMComTopicDataController

+ (UMComTopicDataController *)dataControllerWithTopic:(UMComTopic *)topic
{
    UMComTopicDataController *dataController = [[UMComTopicDataController alloc] init];
    dataController.topic = topic;
    return dataController;
}

+ (void )getTopicWithTopicId:(NSString *)topicID completion:(UMComDataRequestCompletion)completion
{
    UMComTopic* umComTopic = [UMComTopic objectWithObjectId:topicID];
    if (umComTopic && completion) {
        
        completion(umComTopic,nil);
    }
    else{
        [[UMComDataRequestManager defaultManager] fetchTopicWithTopicId:topicID completion:^(NSDictionary *responseObject, NSError *error) {
            UMComTopic *topic = nil;
            if ([responseObject isKindOfClass:[NSDictionary class]] && [responseObject valueForKey:UMComModelDataKey]) {
                topic = [responseObject valueForKey:UMComModelDataKey];
            }
            if (completion) {
                completion(topic, error);
            }
        }];
    }
}

- (void)followOrDisfollowCompletion:(UMComDataRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    BOOL isFollow = ![self.topic.is_focused boolValue];
    [[UMComDataRequestManager defaultManager] topicFollowerWithTopicID:self.topic.topicID isFollow:isFollow completion:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            if (isFollow) {
                weakSelf.topic.is_focused = @1;
            }else{
                weakSelf.topic.is_focused = @0;
            }
        }else{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [UMComDataOperationErrorHandler handleTopicErrorWithTopic:strongSelf.topic error:error];
        }
        if (completion) {
            completion(weakSelf.topic, error);
        }
    }];
}

@end
