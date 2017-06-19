//
//  ZQCustomTabBarVC.m
//  ZQAnimationTabBar
//
//  Created by lzq on 17/6/8.
//  Copyright © 2017年 lzq. All rights reserved.
//

#import "ZQCustomTabBarVC.h"

#import "ViewController.h"

@interface ZQCustomTabBarVC ()<UITabBarControllerDelegate>
{
 
    NSInteger _currentIndex;
}
@end

@implementation ZQCustomTabBarVC

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];

    UIColor *textColor = [UIColor redColor];
    
    UITabBarItem *item1 = [[UITabBarItem alloc] init];
    item1.tag = 1;
    [item1 setTitle:@"首页"];
    [item1 setImage:[UIImage imageNamed:@"home"]];
    [item1 setSelectedImage:[[UIImage imageNamed:@"home-Click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item1 setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor} forState:UIControlStateSelected];
    
    UITabBarItem *item2 = [[UITabBarItem alloc] init];
    item2.tag = 2;
    [item2 setTitle:@"投资"];
    [item2 setImage:[UIImage imageNamed:@"tab-project"]];
    [item2 setSelectedImage:[[UIImage imageNamed:@"tab-Project-Click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item2 setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor} forState:UIControlStateSelected];
   
    UITabBarItem *item3 = [[UITabBarItem alloc] init];
    item3.tag = 3;
    [item3 setTitle:@"借款"];
    [item3 setImage:[UIImage imageNamed:@"tab-new"]];
    [item3 setSelectedImage:[[UIImage imageNamed:@"tab-new-Click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item3 setTitleTextAttributes:@{NSForegroundColorAttributeName:textColor} forState:UIControlStateSelected];
    
    UITabBarItem *item4 = [[UITabBarItem alloc] init];
    item4.tag = 4;
    [item4 setTitle:@"账户"];
    [item4 setImage:[UIImage imageNamed:@"tab-my"]];
    [item4 setSelectedImage:[[UIImage imageNamed:@"tab-my-Click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [item4 setTitleTextAttributes:@{NSForegroundColorAttributeName: textColor}
                         forState:UIControlStateSelected];
    
    
    ViewController *homeController = [[ViewController alloc] init];
    UINavigationController *homeNavController = [[UINavigationController alloc] initWithRootViewController:homeController];
    homeNavController.tabBarItem = item1;
    
    ViewController *investController = [[ViewController alloc] init];
    UINavigationController *projectNavController = [[UINavigationController alloc] initWithRootViewController:investController];
    projectNavController.tabBarItem = item2;
    
    ViewController *loanController = [[ViewController alloc] init];
    UINavigationController *messageNavController = [[UINavigationController alloc] initWithRootViewController:loanController];
    messageNavController.tabBarItem = item3;
    
    ViewController *myController = [[ViewController alloc] init];
    UINavigationController *myNavController = [[UINavigationController alloc] initWithRootViewController:myController];
    myNavController.tabBarItem = item4;
    
    self.viewControllers = [NSArray arrayWithObjects:homeNavController,projectNavController,messageNavController,myNavController, nil];
    self.delegate = self;
    self.selectedIndex = 0;
}

#pragma mark - UITabBarController代理方法 点击事件
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    if (tabBarController.selectedIndex == 3) {
        
    }
    //点击tabBarItem动画
    if (self.selectedIndex != _currentIndex)[self tabBarButtonClick:[self getTabBarButton]];
}

- (UIControl *)getTabBarButton{
    
    NSMutableArray *tabBarButtons = [[NSMutableArray alloc] initWithCapacity:0];

    for (UIView *tabBarButton in self.tabBar.subviews) {
        
        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtons addObject:tabBarButton];
        }
    }
    
    UIControl *tabBarButton = [tabBarButtons objectAtIndex:self.selectedIndex];
    
    return tabBarButton;
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    for (UIView *imageView in tabBarButton.subviews) {
        
        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
            //需要实现的帧动画,这里根据需求自定义
            CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
            
            animation.keyPath = @"transform.scale";
            animation.values = @[@1.0,@1.1,@0.9,@1.0];
            animation.duration = 0.3;
            animation.calculationMode = kCAAnimationCubic;
            //把动画添加上去就OK了
            [imageView.layer addAnimation:animation forKey:nil];

        }
    }
    _currentIndex = self.selectedIndex;
}



@end
