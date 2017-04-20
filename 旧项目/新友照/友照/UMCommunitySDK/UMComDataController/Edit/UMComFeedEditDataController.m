//
//  UMComFeedEditDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/3.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComFeedEditDataController.h"
#import <UMComDataStorage/UMComFeed.h>
#import <UMCommunitySDK/UMComDataTypeDefine.h>
#import <UMCommunitySDK/UMComSession.h>
#import "UMComNotificationMacro.h"

@implementation UMComFeedEditDataController

- (void)createFeedWithCompletion:(UMComDataRequestCompletion)completion
{
    NSArray *topic_ids = nil;
    if (self.topics.count > 0) {
        topic_ids = [self.topics valueForKeyPath:@"topicID"];
    }
    NSArray *uids = nil;
    if (self.atUsers.count > 0) {
        uids = [self.atUsers valueForKeyPath:@"uid"];
    }
    __weak typeof(self) weakSelf = self;
    [UMComDataRequestManager  feedCreateWithContent:self.text
                                              title:self.title
                                           location:self.location
                                       locationName:self.locationDescription
                                       related_uids:uids
                                          topic_ids:topic_ids
                                             images:self.images
                                               type:self.type
                                             custom:self.customContent completion:^(NSDictionary *responseObject, NSError *error) {

        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && !error) {
            id feed  = [responseObject valueForKey:UMComModelDataKey];
            if (feed && [feed isKindOfClass:[UMComFeed class]]) {
                [weakSelf createFeedSucceedWithFeed:feed completion:completion];
                return;
            }
        }

        if (completion) {
            completion(responseObject,error);
        }
    }];
}


//
- (void)forwardFeedWithFeed:(UMComFeed *)forwordFeed completion:(UMComDataRequestCompletion)completion
{
    NSArray *topic_ids = nil;
    if (self.topics.count > 0) {
        topic_ids = [self.topics valueForKeyPath:@"topicID"];
    }
    NSArray *uids = nil;
    if (self.atUsers.count > 0) {
        uids = [self.atUsers valueForKeyPath:@"uid"];
    }
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] feedForwardWithFeedID:forwordFeed.feedID
                                                            content:self.text
                                                          topic_ids:topic_ids
                                                        relatedUids:uids
                                                           feedType:[self.type integerValue]
                                                       locationName:self.locationDescription location:self.location
                                                             custom:self.customContent completion:^(NSDictionary *responseObject, NSError *error) {

        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]] && !error) {
            UMComFeed *feed  = [responseObject valueForKey:UMComModelDataKey];
            if (feed && [feed isKindOfClass:[UMComFeed class]]) {
                if (forwordFeed.origin_feed) {
                    NSInteger feedCount = [forwordFeed.forward_count integerValue];
                    feedCount += 1;
                    forwordFeed.forward_count = @(feedCount);
                }
                [weakSelf createFeedSucceedWithFeed:feed completion:completion];
                return;
            }
        }

        if (completion) {
            completion(nil,error);
        }

    }];
}


- (void)createFeedSucceedWithFeed:(UMComFeed *)newFeed completion:(UMComDataRequestCompletion)completion
{
    UMComUser *loginUser = [UMComSession sharedInstance].loginUser;
    loginUser.feed_count = @(loginUser.feed_count.integerValue + 1);
    if (completion) {
        completion(newFeed,nil);
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPostFeedResultNotification object:newFeed];
}

@end
