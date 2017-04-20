//
//  UMComPrivateLetterListDataController.m
//  UMCommunity
//
//  Created by umeng on 16/6/29.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComPrivateLetterListDataController.h"
#import <UMCommunitySDK/UMComDataRequestManager.h>
#import "UMComUserDataController.h"

@implementation UMComPrivateLetterListDataController

- (instancetype)initWithCount:(NSInteger)count
{
    self = [super initWithRequestType:UMComRequestType_PrivateLetter count:count];
    if (self) {
    }
    return self;
}

+ (UMComPrivateLetterListDataController *)privateLetterListDataControllerWithCount:(NSInteger)cout
{
    UMComPrivateLetterListDataController *privateDataContrller = [[[self class] alloc] initWithCount:cout];
    return privateDataContrller;
}


- (void)creatChartBoxWithToUser:(UMComUser * __nonnull)user
                     completion:(UMComDataRequestCompletion __nullable)completion
{
    UMComUserDataController *userDataController = [UMComUserDataController userDataControllerWithUser:user];
    [userDataController creatChartBoxWithCompletion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(responseObject, error);
        }
    }];
}

- (void)refreshNewDataCompletion:(UMComDataListRequestCompletion)completion
{
    __weak typeof(self) weakSelf = self;
    [[UMComDataRequestManager defaultManager] fetchPrivateLetterWithCount:self.count completion:^(NSDictionary *responseObject, NSError *error) {
        [weakSelf handleNewData:responseObject error:error completion:completion];
    }];
}

@end
