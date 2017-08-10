//
//  BaseNavigationC.m
//  CDBLG
//
//  Created by JuZhenBaoiMac on 2017/4/22.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "BaseNavigationC.h"

#import "AppDelegate.h"

@interface BaseNavigationC ()

@end

@implementation BaseNavigationC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = k_themeColor;// 设置导航栏背景颜色
    [self.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:k_fontSize_1Class,
       NSForegroundColorAttributeName:k_fontColor_normal}];// 设置导航栏文字字体大小 文字的颜色
}

//push时隐藏tabbar
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
//    NSString *tabBarItems = [kUserDefaults objectForKey:@"tabBarItems"];
//    if ([tabBarItems isEqualToString:@"6"]) {
//        AppDelegate *delegate = (AppDelegate *)kAppDelegate;
//        [delegate.tabBarC_6.tabBar mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(0);
//        }];
//    }
    [super pushViewController:viewController animated:animated];
}
//- (nullable UIViewController *)popViewControllerAnimated:(BOOL)animated{
//    UIViewController *vc = [super popViewControllerAnimated:animated];
//    
//    if (self.childViewControllers.count == 1) {
//        NSString *tabBarItems = [kUserDefaults objectForKey:@"tabBarItems"];
//        if ([tabBarItems isEqualToString:@"6"]) {
//            AppDelegate *delegate = (AppDelegate *)kAppDelegate;
//            [delegate.tabBarC_6.tabBar mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.height.mas_equalTo(50);
//            }];
//        }
//    }
//    
//    return vc;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
