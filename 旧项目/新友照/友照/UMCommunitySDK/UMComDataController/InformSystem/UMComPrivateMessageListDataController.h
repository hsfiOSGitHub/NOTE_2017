//
//  UMComPrivateMessageListDataController.h
//  UMCommunity
//
//  Created by umeng on 16/6/29.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"

@class UMComPrivateLetter;

@interface UMComPrivateMessageListDataController : UMComListDataController


@property (nonatomic, strong) UMComPrivateLetter *privateLetter;

+ (UMComPrivateMessageListDataController *)privateMessageListDataControllerWithPrivateLetter:(UMComPrivateLetter * __nonnull)privateLetter count:(NSInteger)count;

- (instancetype)initWithCount:(NSInteger)count privateLetter:(UMComPrivateLetter *)privateLetter;

- (void)sendMessageToUser:(UMComUser *)user message:(NSString *)content completion:(UMComDataRequestCompletion)completion;


@end
