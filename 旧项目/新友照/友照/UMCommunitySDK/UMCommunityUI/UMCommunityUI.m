//
//  UMCommunityUI.m
//  UMCommunity
//
//  Created by wyq.Cloudayc on 7/31/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import "UMCommunityUI.h"
#import "UMComNavigationController.h"

@implementation UMCommunityUI

+ (UINavigationController *)navigationViewController
{
    UIViewController *feedsViewController = [self currentViewController];
    UMComNavigationController *navigationControlller = [[UMComNavigationController alloc] initWithRootViewController:feedsViewController];
    
    return navigationControlller;
}


+ (UIViewController *)viewController
{
    UIViewController *feedsViewController = [self currentViewController];
    return feedsViewController;
}

+ (UIViewController *)currentViewController
{
    Class UMComCurrentViewController = nil;
    if (NSClassFromString(@"UMComHomeFeedViewController")) {
        UMComCurrentViewController = NSClassFromString(@"UMComHomeFeedViewController");
    }else if (NSClassFromString(@"UMComForumHomeViewController")){
        UMComCurrentViewController = NSClassFromString(@"UMComForumHomeViewController");
    }else if (NSClassFromString(@"UMComSimpleHomeViewController")){
        UMComCurrentViewController = NSClassFromString(@"UMComSimpleHomeViewController");
    }else if (NSClassFromString(@"UMComViewController")){
        UMComCurrentViewController = NSClassFromString(@"UMComViewController");
    }else{
        return [[UIViewController alloc] init];
    }
    UIViewController *currentViewController = [[UMComCurrentViewController alloc] init];
    return currentViewController;
}

@end
