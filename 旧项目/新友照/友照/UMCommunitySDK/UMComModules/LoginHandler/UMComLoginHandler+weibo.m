//
//  UMComLoginHandler+weibo.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 8/4/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMComLoginHandler+weibo.h"
#import "UMComUserCenterViewController.h"
#import "UMComTopicsTableViewController.h"
#import "UMComUserTableViewController.h"
#import "UMComUserListDataController.h"
#import "UMComTopicListDataController.h"
#import "UMComNavigationController.h"
#import <UMComFoundation/UMComKit+Runtime.h>

@implementation UMComLoginHandler (weibo)

+ (void)load
{
    [self activeWeibo];
}

+ (void)activeWeibo
{
    [UMComKit swizzleInstanceMethod:[self class]
                   originalSelector:@selector(showRecommendUserWithViewController:completion:)
                   swizzledSelector:@selector(swizzle_showWeiboRecommendUserWithViewController:completion:)];
    [UMComKit swizzleInstanceMethod:[self class]
                   originalSelector:@selector(showRecommendTopicWithViewController:completion:)
                   swizzledSelector:@selector(swizzle_showWeiboRecommendTopicWithViewController:completion:)];
}

- (void)swizzle_showWeiboRecommendUserWithViewController:(UIViewController *)viewController
                                         completion:(void (^)(UIViewController *recommendUserVC))completion
{
    UMComUserTableViewController *userRecommendViewController = [[UMComUserTableViewController alloc] initWithCompletion:completion];
    userRecommendViewController.isAutoStartLoadData = YES;
    
    userRecommendViewController.callbackBlock = ^(UMComUserTableViewController *controller, UMComUserTableViewCallBackEvent event, UMComUser *user) {
        UMComUserCenterViewController *vc = [[UMComUserCenterViewController alloc] initWithUser:user];
        vc.userOperationFinishDelegate = controller.userOperationFinishDelegate;
        [controller.navigationController pushViewController:vc animated:YES];
    };
    
    userRecommendViewController.title = UMComLocalizedString(@"um_com_user_recommend", @"用户推荐");
    userRecommendViewController.dataController = [[UMComUserRecommendDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    [viewController.navigationController pushViewController:userRecommendViewController animated:YES];
}

- (void)swizzle_showWeiboRecommendTopicWithViewController:(UIViewController *)viewController completion:(void (^)(UIViewController *recommendTopicVC))completion
{
    UMComTopicsTableViewController *topicsRecommendViewController = [[UMComTopicsTableViewController alloc] initWithCompletion:completion];
    topicsRecommendViewController.completion = completion;
    topicsRecommendViewController.isAutoStartLoadData = YES;
    topicsRecommendViewController.isShowNextButton = YES;
    topicsRecommendViewController.title = UMComLocalizedString(@"user_topic_recommend", @"话题推荐");
    topicsRecommendViewController.dataController = [[UMComTopicsRecommendDataController alloc] initWithCount:UMCom_Limit_Page_Count];
    UMComNavigationController *topicsNav = [[UMComNavigationController alloc] initWithRootViewController:topicsRecommendViewController];
    [viewController presentViewController:topicsNav animated:YES completion:nil];
}
@end
