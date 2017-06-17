//
//  MainTabBarController.m
//  TravelTV
//
//  Created by JuZhenBaoiMac on 2017/3/20.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "MainTabBarController.h"
////vc
//#import "HomeVC.h"
//#import "OrdersVC.h"
//#import "MineVC.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBar.translucent = NO;
    
    //添加子控制器
//    HomeVC *vc1 = [[HomeVC alloc]init];
//    OrdersVC *vc2 = [[OrdersVC alloc]init];
//    MineVC *vc3 = [[MineVC alloc]init];
//    
//    [self addChildVC:vc1 title:@"首页" image:@"tabber_home_normal" selectedImage:@"laber_home_b"];
//    [self addChildVC:vc2 title:@"订单" image:@"laber_indent_a" selectedImage:@"label_order_b"];
//    [self addChildVC:vc3 title:@"我的" image:@"laber_me_a" selectedImage:@"label_me_b"];
}


/**
 *  添加一个子控制器
 *
 *  @param childVC       子控制器
 *  @param title         标题
 *  @param image         图片
 *  @param selectedImage 选中的图片
 */
- (void)addChildVC:(UIViewController *)childVC title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage{
    // 设置子控制器的文字(可以设置tabBar和navigationBar的文字)
    childVC.title = title;
    
    // 设置子控制器的tabBarItem图片
    childVC.tabBarItem.image = [[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 禁用图片渲染
    childVC.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor]} forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]} forState:UIControlStateSelected];
    
    // 为子控制器包装导航控制器
    BaseNavigationC *navi = [[BaseNavigationC alloc] initWithRootViewController:childVC];
    navi.navigationBar.barTintColor = k_themeColor;// 设置导航栏背景颜色
    [navi.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:k_fontSize_1Class,
       NSForegroundColorAttributeName:[UIColor whiteColor]}];// 设置导航栏文字字体大小 文字的颜色
    // 添加子控制器
    [self addChildViewController:navi];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
