//
//  UMComTopicGroupDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/5.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComTopicGroupDataController.h"
#import <UMComDataStorage/UMComTopicType.h>
#import <UMCommunitySDK/UMComDataTypeDefine.h>

@implementation UMComTopicGroupDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_TopicGroups count:count];
    if (self) {
        
    }
    return self;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakself  = self;
    [[UMComDataRequestManager defaultManager] fetchTopicGroupdsWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        //[weakself handleResponse:responseObject withError:error withRequestCompletion:completion];
        [weakself handleNewData:responseObject error:error completion:completion];
    }];
    
}

@end
