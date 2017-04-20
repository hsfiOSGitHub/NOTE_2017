//
//  UMCommunityUI.h
//  UMCommunity
//
//  Created by wyq.Cloudayc on 7/31/16.
//  Copyright © 2016 Umeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMCommunityUI : NSObject

/**
 *  获取微社区主页NavigationController
 *
 *  @return 微社区主页NavigationController
 */
+ (UINavigationController *)navigationViewController;

/**
 *  获取微社区主页UIViewController对象，可直接push到UINavigationController
 *  如果没有UINavigationController，可使用naviagtionViewController接口
 *  @return 微社区主页ViewController
 */
+ (UIViewController *)viewController;

@end
