//
//  UMengLoginHandler.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComLoginHandler.h"
#import "UMComNavigationController.h"
#import <UMComNetwork/UMComHttpCode.h>
#import "UMComProfileSettingController.h"

@interface UMComLoginHandler()


@end

@implementation UMComLoginHandler

static UMComLoginHandler *_instance = nil;
+ (void)load
{
    [self bindLoginHandler];
}

+ (void)bindLoginHandler
{
    [UMComLoginManager shareInstance].loginHandler = [[self alloc] init];
}

- (void)setAppKey:(NSString *)appKey
{
    
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return NO;
}

- (void)presentLoginViewController:(UIViewController *)viewController finishResponse:(void (^)(id, NSError *))completion
{
    UMComLoginViewController *loginViewController = [[UMComLoginViewController alloc] init];
    UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
    [viewController presentViewController:navigationController animated:YES completion:nil];
}


- (void)handleLoginError:(NSError *)error inViewController:(UIViewController *)rootViewController withLoginData:(UMComLoginUser *)loginUser
{
    if (error.code == ERR_CODE_USER_NAME_LENGTH_ERROR || error.code == ERR_CODE_USER_NAME_SENSITIVE || error.code == ERR_CODE_USER_NAME_DUPLICATE || error.code == ERR_CODE_USER_NAME_CONTAINS_ILLEGAL_CHARS) {
        [self updateProfileInViewController:rootViewController withLoginData:loginUser forRegisterSetting:YES completion:nil];
    }
}

- (void)updateProfileInViewController:(UIViewController *)rootViewController withLoginData:(UMComLoginUser *)loginUser completion:(dispatch_block_t)completion
{
    if (loginUser.updatedProfile) {
        if (completion) {
            completion();
        }
        return;
    }
    [self updateProfileInViewController:rootViewController withLoginData:loginUser forRegisterSetting:NO completion:completion];
}

- (void)updateProfileInViewController:(UIViewController *)rootViewController withLoginData:(UMComLoginUser *)loginUser forRegisterSetting:(BOOL)forRegister completion:(dispatch_block_t)completion
{
    UMComProfileSettingController *profileController = [[UMComProfileSettingController alloc] init];
    profileController.forRegister = forRegister;
    profileController.updateCompletion = completion;
    profileController.userAccount = loginUser;
    UMComNavigationController *profileNaviController = [[UMComNavigationController alloc] initWithRootViewController:profileController];
    [rootViewController presentViewController:profileNaviController animated:YES completion:nil];
}


#pragma mark - 显示推荐页面
- (void)handleEventAfterRegister:(UIViewController *)rootViewController completion:(dispatch_block_t)completion
{
    [self showRecommendViewControllerWithLoginViewController:rootViewController loginComletion:completion];
}

- (void)showRecommendViewControllerWithLoginViewController:(UIViewController *)viewController loginComletion:(void (^)())loginCompletion
{
    [self showRecommendTopicWithViewController:viewController completion:^(UIViewController *recommendTopicVC) {
        [self showRecommendUserWithViewController:recommendTopicVC completion:^(UIViewController *recommendUserVC) {
            [recommendUserVC dismissViewControllerAnimated:YES completion:loginCompletion];
        }];
    }];
}

- (void)showRecommendUserWithViewController:(UIViewController *)viewController
                                      completion:(void (^)(UIViewController *recommendUserVC))completion
{
    completion(nil);
}

- (void)showRecommendTopicWithViewController:(UIViewController *)viewController completion:(void (^)(UIViewController *recommendTopicVC))completion
{
    completion(nil);
}

@end
