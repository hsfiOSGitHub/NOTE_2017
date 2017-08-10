//
//  AppDelegate.m
//  CDDMall
//
//  Created by apple on 2017/5/26.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "AppDelegate.h"
#import "JKDBModel.h"
#import "DCTabBarController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.window.rootViewController = [[DCTabBarController alloc] init];
    
    [self.window makeKeyAndVisible];
    
    [self setUpUserData]; //设置数据
    
    return YES;
}


/**
 是否登录
 */
- (void)setUpUserData
{
    DCUserInfo *userInfo = UserInfoData;
    if (userInfo.username.length == 0) { //userName为指定id不可改动用来判断是否有用户数据
        DCUserInfo *userInfo = [[DCUserInfo alloc] init];
        userInfo.nickname = @"RocketsChen";
        userInfo.sex = @"男";
        userInfo.birthDay = @"1996-02-10";
        userInfo.userimage = @"icon";
        userInfo.username = @"qq-w923740293";
        userInfo.defaultAddress = @"江苏 苏州吴中";
        dispatch_async(dispatch_get_global_queue(0, 0), ^{//异步保存
            [userInfo save];
        });
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
