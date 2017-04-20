//
//  UMComLoginManager.m
//  UMCommunity
//
//  Created by Gavin Ye on 8/25/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComShareManager.h"
#import "UMComShareDelegate.h"
#import <UMCommunitySDK/UMCommunitySDK.h>

@interface UMComShareManager ()

@end

@implementation UMComShareManager

static UMComShareManager *_instance = nil;

+ (void)load
{
    [self shareInstance];
}

+ (UMComShareManager *)shareInstance {
    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[UMComShareManager alloc] init];
        }
    }
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        Class delegateClass = NSClassFromString(@"UMComShareDelegateHandler");
        self.shareHadleDelegate = [[delegateClass alloc] init];
        [self registerNotifications];
    }
    return self;
}

- (void)registerNotifications
{
    __weak typeof(self) ws = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kUMComUpdateAppKeyNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [ws setAppKey:[UMCommunitySDK appKey]];
    }];
}

- (void)setAppKey:(NSString *)appKey
{
    if ([self.shareHadleDelegate respondsToSelector:@selector(setAppKey:)]) {
        [self.shareHadleDelegate setAppKey:appKey];
    }
}

+ (BOOL)handleOpenURL:(NSURL *)url
{
    if ([[self shareInstance].shareHadleDelegate respondsToSelector:@selector(handleOpenURL:)]) {
        return [[self shareInstance].shareHadleDelegate handleOpenURL:url];
    }
    return NO;
}

@end
