//
//  UMengLoginHandler.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComSimpleLoginHandler.h"
#import "UMComNavigationController.h"
#import "UMComLoginManager.h"

#import "UMComLoginViewController.h"
#import "UMComSimpleProfileSettingController.h"

@interface UMComSimpleLoginHandler()


@end

@implementation UMComSimpleLoginHandler

static UMComSimpleLoginHandler *_instance = nil;

+ (void)load
{
    [self binYZLoginHandler];
}

+ (void)binYZLoginHandler
{
    [UMComLoginManager shareInstance].loginHandler = [[self alloc] init];
}

- (void)presentLoginViewController:(UIViewController *)viewController finishResponse:(LoginCompletion)completion
{
    UMComLoginViewController *loginViewController = [[UMComLoginViewController alloc] initWithExclusiveLogin:YES];
    UMComNavigationController *navigationController = [[UMComNavigationController alloc] initWithRootViewController:loginViewController];
    if (viewController) {
        [viewController presentViewController:navigationController animated:YES completion:nil];
    }else{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:navigationController animated:YES completion:nil];
    }
}

- (void)updateProfileInViewController:(UIViewController *)rootViewController withLoginData:(UMComLoginUser *)loginUser completion:(dispatch_block_t)completion
{
    [self updateProfileInViewController:rootViewController completion:completion];
}

- (void)updateProfileInViewController:(UIViewController *)viewController completion:(dispatch_block_t)completion
{
    UMComSimpleProfileSettingController *VC = [[UMComSimpleProfileSettingController alloc] init];
    VC.hideLogout = YES;
    VC.updateCompletion = completion;
    UMComNavigationController *rootLoginNav = [[UMComNavigationController alloc] initWithRootViewController:VC];
    [viewController.navigationController presentViewController:rootLoginNav animated:YES completion:nil];
}

@end
