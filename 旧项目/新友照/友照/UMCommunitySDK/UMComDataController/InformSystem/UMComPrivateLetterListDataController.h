//
//  UMComPrivateLetterListDataController.h
//  UMCommunity
//
//  Created by umeng on 16/6/29.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComListDataController.h"

@class UMComUser;
@interface UMComPrivateLetterListDataController : UMComListDataController

+ (UMComPrivateLetterListDataController *)privateLetterListDataControllerWithCount:(NSInteger)cout;

- (void)creatChartBoxWithToUser:(UMComUser * __nonnull)user
                     completion:(UMComDataRequestCompletion __nullable)completion;

@end
