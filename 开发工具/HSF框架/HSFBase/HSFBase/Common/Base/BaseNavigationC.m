//
//  BaseNavigationC.m
//  CDBLG
//
//  Created by JuZhenBaoiMac on 2017/4/22.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "BaseNavigationC.h"

@interface BaseNavigationC ()

@end

@implementation BaseNavigationC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.barTintColor = k_themeColor;// 设置导航栏背景颜色
    [self.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:k_fontSize_1Class,
       NSForegroundColorAttributeName:[UIColor whiteColor]}];// 设置导航栏文字字体大小 文字的颜色
}

//push时隐藏tabbar
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
