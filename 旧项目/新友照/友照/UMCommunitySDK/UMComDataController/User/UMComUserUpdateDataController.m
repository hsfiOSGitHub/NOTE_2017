//
//  UMComUserUpdateDataController.m
//  UMCommunity
//
//  Created by umeng on 16/5/4.
//  Copyright © 2016年 Umeng. All rights reserved.
//

#import "UMComUserUpdateDataController.h"
#import <UMCommunitySDK/UMComDataRequestManager.h>
#import <UMCommunitySDK/UMComSession.h>
#import <UMComDataStorage/UMComUser.h>
#import <UMComDataStorage/UMComDataBaseManager.h>
#import <UMCommunitySDK/UMComDataTypeDefine.h>
#import "UMComNotificationMacro.h"
#import <UMComDataStorage/UMComImageUrl.h>
#import <UIKit/UIKit.h>

@implementation UMComUserUpdateDataController


- (void)updateAvatarWithImage:(id)image
                   completion:(UMComDataRequestCompletion)completion
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[UMComDataRequestManager defaultManager] userUpdateAvatarWithImage:image completion:^(NSDictionary *responseObject, NSError *error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (!error) {
            UMComCreatorIconUrl *imageUrl = responseObject[UMComModelDataKey];
            if (imageUrl && [UMComSession sharedInstance].loginUser) {
                [UMComSession sharedInstance].loginUser.icon_url = imageUrl;
                
                [[UMComDataBaseManager shareManager] saveRelatedIDTableWithType:UMComRelatedRegisterUserID withUsers:@[[UMComSession sharedInstance].loginUser]];
                
                NSArray* loginUserArray = [[UMComDataBaseManager shareManager] fetchSyncUMComUserWithType:UMComRelatedRegisterUserID];
                
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:kUserUpdateAvatarSucceedNotification object:image];
        }
        if (completion) {
            completion(responseObject, error);
        }
    }];
}

- (void)updateProfileWithName:(NSString *)name
                          age:(NSNumber *)age
                       gender:(NSNumber *)gender
                       custom:(NSString *)custom
                 userNameType:(UMComUserNameType)userNameType
               userNameLength:(UMComUserNameLength)userNameLength
                   completion:(UMComDataRequestCompletion)completion
{
    
    [[UMComDataRequestManager defaultManager] updateProfileWithName:name age:age gender:gender custom:custom userNameType:userNameDefault userNameLength:userNameLengthDefault completion:^(NSDictionary *responseObject, NSError *error) {
        if (!error) {
            UMComUser *user = [UMComSession sharedInstance].loginUser;
            if (name) {
                user.name = name;
            }
            if (age) {
                user.age = age;
            }
            if (gender) {
                user.gender = gender;
            }
            
            if (user && [user isKindOfClass:[UMComUser class]]) {
                [[UMComDataBaseManager shareManager] saveRelatedIDTableWithType:UMComRelatedRegisterUserID withUsers:@[user]];
            }

            [[NSNotificationCenter defaultCenter] postNotificationName:kUserUpdateProfileSucceedNotification object:nil];
        }
        if (completion) {
            completion(responseObject, error);
        }
    }];
}

@end
