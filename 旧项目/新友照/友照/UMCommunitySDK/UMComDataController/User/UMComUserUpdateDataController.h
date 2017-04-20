//
//  UMComUserUpdateDataController.h
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMCommunitySDK/UMComDataRequestManager.h>

@interface UMComUserUpdateDataController : NSObject

- (void)updateAvatarWithImage:(id)image
                   completion:(UMComDataRequestCompletion)completion;

- (void)updateProfileWithName:(NSString *)name
                          age:(NSNumber *)age
                       gender:(NSNumber *)gender
                       custom:(NSString *)custom
                 userNameType:(UMComUserNameType)userNameType
               userNameLength:(UMComUserNameLength)userNameLength
                   completion:(UMComDataRequestCompletion)completion;

@end
