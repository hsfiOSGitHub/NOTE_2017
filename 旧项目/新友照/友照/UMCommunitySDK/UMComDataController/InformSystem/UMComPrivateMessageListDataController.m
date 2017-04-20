//
//  UMComPrivateMessageListDataController.m
//  UMCommunity
//
//  Created by umeng on 16/6/29.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComPrivateMessageListDataController.h"
#import <UMCommunitySDK/UMComDataRequestManager.h>
#import <UMComDataStorage/UMComPrivateLetter.h>
#import <UMComDataStorage/UMComUser.h>
#import "UMComUserDataController.h"

@implementation UMComPrivateMessageListDataController

- (instancetype)initWithCount:(NSInteger)count privateLetter:(UMComPrivateLetter *)privateLetter
{
    self = [super initWithRequestType:UMComRequestType_PrivateMessage count:count];
    if (self) {
        self.privateLetter = privateLetter;
    }
    return self;
}


+ (UMComPrivateMessageListDataController *)privateMessageListDataControllerWithPrivateLetter:(UMComPrivateLetter *)privateLetter count:(NSInteger)count
{
    UMComPrivateMessageListDataController *dataController = [[UMComPrivateMessageListDataController alloc] initWithCount:count privateLetter:privateLetter];
    dataController.privateLetter = privateLetter;
    return dataController;
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self)weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchPrivateChartRecordWithUid:self.privateLetter.user.uid private_letter_id:self.privateLetter.letter_id count:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

- (void)sendMessageToUser:(UMComUser *)user message:(NSString *)content completion:(UMComDataRequestCompletion)completion
{
    UMComUserDataController *userDataController = [UMComUserDataController userDataControllerWithUser:user];
    [userDataController sendUserPrivateMessage:content completion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(responseObject, error);
        }
    }];
}

@end
