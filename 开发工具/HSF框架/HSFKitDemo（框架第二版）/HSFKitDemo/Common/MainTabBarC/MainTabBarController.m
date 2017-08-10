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
    
//    //添加子控制器
//    HomeVC *vc_home = [[HomeVC alloc]init];
//    CycleVC *vc_cycle = [[CycleVC alloc]init];
//    WarehouseVC *vc_warehouse = [[WarehouseVC alloc]init];
////    ShopManagerVC *vc_shopManager = [[ShopManagerVC alloc]init];
//    ShoppingCarVC *vc_shoppingCar = [[ShoppingCarVC alloc]init];
//    MineVC *vc_mine = [[MineVC alloc]init];
//    
//    [self addChildVC:vc_home title:@"首页" image:@"tabbar_home_nor" selectedImage:@"tabbar_home_sel"];
//    [self addChildVC:vc_cycle title:@"汽配圈" image:@"tabbar_carCycle_nor" selectedImage:@"tabbar_carCycle_sel"];
//    [self addChildVC:vc_warehouse title:@"进销存" image:@"tabbar_invoicing_nor" selectedImage:@"tabbar_invoicing_sel"];
////    [self addChildVC:vc_shopManager title:@"店铺管理" image:@"iphone" selectedImage:@"iphone"];
//    [self addChildVC:vc_shoppingCar title:@"购物车" image:@"tabbar_shoppingCar_nor" selectedImage:@"tabbar_shoppingCar_sel"];
//    [self addChildVC:vc_mine title:@"个人中心" image:@"tabbar_me_nor" selectedImage:@"tabbar_me_sel"];
    
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
