//
//  UMComMessageManager.m
//  UMCommunity
//
//  Created by Gavin Ye on 11/10/14.
//  Copyright (c) 2014 Umeng. All rights reserved.
//

#import "UMComMessageManager.h"
#import <UMComFoundation/UMUtils.h>
#import "UMComLoginManager.h"
#import "UMComNavigationController.h"
#import "UMComResouceDefines.h"
#import <UMCommunitySDK/UMComSession.h>
#import <UMCommunitySDK/UMCommunitySDK.h>

@interface UMComMessageManager()

@property (nonatomic, strong) id<UMComMessageDelegate>messageDelegate;
@property (nonatomic, strong) UMComPushDetailViewBlock pushViewBlock;

@end

@implementation UMComMessageManager


+ (void)load
{
    [self sharedInstance];
}

+ (UMComMessageManager *)sharedInstance {
    static UMComMessageManager *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[UMComMessageManager alloc] init];
        
    });
    return _instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.messageDelegate = [[NSClassFromString(@"UMComUMengMessageHandler") alloc] init];
        [self registerNotifications];
    }
    return self;
}

- (void)registerNotifications
{
    __weak typeof(self) ws = self;
    [[NSNotificationCenter defaultCenter] addObserverForName:kUMComUpdateAppKeyNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [ws setAppkey:[UMCommunitySDK appKey]];
    }];
}

+ (void)setMessageDelegate:(id<UMComMessageDelegate>)messageDelegate
{
    if (messageDelegate) {
        [self sharedInstance].messageDelegate =  messageDelegate;
    } else {
        UMLog(@"you must set a message delegate!");
    }
}

- (void)setAppkey:(NSString *)appKey
{
    if (!appKey) {
        UMLog(@"appkey can not be nil!");
    }
    if ([[[NSUserDefaults standardUserDefaults] valueForKey:@"UMComMessageAddAliasFail"] boolValue]) {
        if ([UMComSession sharedInstance].uid) {
            [UMComMessageManager addAlias:[UMComSession sharedInstance].uid type:kNSAliasKey response:^(id responseObject, NSError *error) {
                if (error) {
                    //添加alias失败的话在每次启动时候重新添加
                    [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:@"UMComMessageAddAliasFail"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                } else {
                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UMComMessageAddAliasFail"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
            }];
        }
    }
}

+ (void)startWithOptions:(NSDictionary *)launchOptions
{
    id<UMComMessageDelegate> messageDelegate = [self sharedInstance].messageDelegate;
    if (messageDelegate && [messageDelegate respondsToSelector:@selector(startWithAppKey:launchOptions:)]) {
        [messageDelegate startWithAppKey:[UMCommunitySDK appKey] launchOptions:launchOptions];
    }
}

+ (void)registerDeviceToken:(NSData *)deviceToken{
    id<UMComMessageDelegate> messageDelegate = [self sharedInstance].messageDelegate;
    if (messageDelegate && [messageDelegate respondsToSelector:@selector(registerDeviceToken:)]) {
        [messageDelegate registerDeviceToken:deviceToken];
    }
}

+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //如果是接收友盟微社区消息通知， 则刷新未读消息数
    if ([userInfo valueForKey:@"umwsq"]) {
        [[UMComSession sharedInstance] refreshConfigDataWithCompletion:nil];
    }
    id<UMComMessageDelegate> messageDelegate = [self sharedInstance].messageDelegate;
    if (messageDelegate && [messageDelegate respondsToSelector:@selector(didReceiveRemoteNotification:)]) {
        [messageDelegate didReceiveRemoteNotification:userInfo];
    }
}

+ (void)addAlias:(NSString *)name type:(NSString *)type response:(void (^)(id responseObject,NSError *error))handle
{
    id<UMComMessageDelegate> messageDelegate = [self sharedInstance].messageDelegate;
    if (messageDelegate && [messageDelegate respondsToSelector:@selector(addAlias:type:response:)]) {
        [messageDelegate addAlias:name type:type response:^(id responseObject, NSError *error) {
            SafeCompletionDataAndError(handle, responseObject, error);
        }];
    }
}

+ (void)removeAlias:(NSString *)name type:(NSString *)type response:(void (^)(id, NSError *))handle
{
    id<UMComMessageDelegate> messageDelegate = [self sharedInstance].messageDelegate;
    if (messageDelegate && [messageDelegate respondsToSelector:@selector(removeAlias:type:response:)]) {
        [messageDelegate removeAlias:name type:type response:handle];
    }
}

+ (void)handleUserInfo:(NSDictionary *)userInfo
{
//    UIViewController *controller = nil;
    NSString *feed_id = nil;
    NSString *comment_id = nil;

        UIViewController *rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        UIViewController * presentedViewController = rootViewController.presentedViewController;
        if (presentedViewController) {
            while (presentedViewController) {
                if (presentedViewController.presentedViewController){
                    presentedViewController = presentedViewController.presentedViewController;
                } else {
                    break;
                }
            }
        } else {
            presentedViewController = rootViewController;
        }
        
        NSString *controllerName = [userInfo valueForKey:@"umeng_comm_afteropen_controller"];
        if ([controllerName isEqualToString:@"UMComFeedDetailViewController"]) {
            if ([userInfo valueForKey:@"feed_id"]) {
                feed_id = [userInfo valueForKey:@"feed_id"];
            }
            if ([userInfo valueForKey:@"comment_id"]){
                comment_id = [userInfo valueForKey:@"comment_id"];
            }
            
            [self handleExtraInfo:userInfo];
            
            if ([feed_id isKindOfClass:[NSString class]]) {
                [UMComLoginManager performLogin:presentedViewController completion:^(id responseObject, NSError *error) {
                    if (!error) {
                        NSMutableDictionary * extraDic = [NSMutableDictionary dictionary];
                        if (feed_id) {
                            [extraDic setValue:feed_id forKey:@"feed_id"];
                        }
                        if (comment_id) {
                            [extraDic setValue:comment_id forKey:@"comment_id"];
                        }
                        UIViewController *viewController = [self getDetailVCWithFeedId:feed_id ExtraDict:extraDic];
                        if (viewController) {
                            UMComNavigationController *feedDetailNav = [[UMComNavigationController alloc] initWithRootViewController:viewController];
                            [presentedViewController presentViewController:feedDetailNav animated:YES completion:nil];
                        }
                        else
                        {
                            Class UMComRemoteNoticeViewController = NSClassFromString(@"UMComRemoteNoticeViewController");
                            UIViewController *remoteNoticeViewController = [[UMComRemoteNoticeViewController alloc] init];
                            UMComNavigationController *feedDetailNav = [[UMComNavigationController alloc] initWithRootViewController:remoteNoticeViewController];
                            [presentedViewController presentViewController:feedDetailNav animated:YES completion:nil];
                        }

                    }
                }];
                
            }
        }
        else if ([controllerName isEqualToString:@"UMComRemoteNoticeViewController"]){
            [UMComLoginManager performLogin:presentedViewController completion:^(id responseObject, NSError *error) {
                if (!error) {
                    Class UMComRemoteNoticeViewController = NSClassFromString(@"UMComRemoteNoticeViewController");
                    UIViewController *remoteNoticeViewController = [[UMComRemoteNoticeViewController alloc] init];
                    UMComNavigationController *feedDetailNav = [[UMComNavigationController alloc] initWithRootViewController:remoteNoticeViewController];
                    [presentedViewController presentViewController:feedDetailNav animated:YES completion:nil];
                }
            }];
        }
}

+ (UIViewController *)getDetailVCWithFeedId:(NSString *)feedId ExtraDict:(NSDictionary *)extraDic
{
    UIViewController *viewController = nil;
    if (NSClassFromString(@"UMComPostContentViewController")) {
        Class cls = NSClassFromString(@"UMComPostContentViewController");
        UIViewController *vc = [cls alloc];
        SEL sel = NSSelectorFromString(@"initWithFeed:viewExtra:");
        if ([vc respondsToSelector:sel]) {
            [vc performSelector:sel withObject:feedId withObject:extraDic];
        }
        viewController = vc;
    } else
        if(NSClassFromString(@"UMComFeedDetailViewController")) {
        Class cls = NSClassFromString(@"UMComFeedDetailViewController");
        UIViewController *vc = [cls alloc];
        SEL sel = NSSelectorFromString(@"initWithFeed:viewExtra:");
        if ([vc respondsToSelector:sel]) {
            [vc performSelector:sel withObject:feedId withObject:extraDic];
        }
        viewController = vc;
    }
    return viewController;
}

+ (void)handleExtraInfo:(NSDictionary *)userInfo
{
}

+ (void)remoteNotificationForEnterDetailView:(UMComPushDetailViewBlock)handle
{
    [self sharedInstance].pushViewBlock = handle;
}

@end
