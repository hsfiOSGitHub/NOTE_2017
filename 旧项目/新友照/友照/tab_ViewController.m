//
//  tab_ViewController.m
//  友照
//
//  Created by ZX on 16/11/21.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

//导航栏
#import "nav_ViewController.h"
//主页
#import "zhu_ye_ViewController.h"
//驾考
#import "jia_kao_ViewController.h"
//社区
#import "ZXCommunityViewControlller.h"
//我的
#import "wo_de_ViewController.h"

#import "tab_ViewController.h"

@interface tab_ViewController ()
//社区

@property (nonatomic, strong)UINavigationController *communityViewController;

@end

@implementation tab_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addAllChildVcs];
}
-(void)addAllChildVcs{
    
    zhu_ye_ViewController* zhuye = [[zhu_ye_ViewController alloc] init];
    [self addchildVC:zhuye Andimage:[UIImage imageNamed:@"主页"] AndselectedImage:[UIImage imageNamed:@"主页选中"] Andtitle:@"主页"];
    
    jia_kao_ViewController *jiakao =[[jia_kao_ViewController alloc]init];
     [self addchildVC:jiakao Andimage:[UIImage imageNamed:@"驾考"]AndselectedImage:[UIImage imageNamed:@"驾考选中"] Andtitle:@"驾考"];
    _communityViewController = [UMCommunityUI navigationViewController];
    _communityViewController.view.backgroundColor = [UIColor whiteColor];
    [self addchildVC:_communityViewController Andimage:[UIImage imageNamed:@"社区"] AndselectedImage:[UIImage imageNamed:@"社区选中"] Andtitle:@"社区"];
    
    wo_de_ViewController *wode = [[wo_de_ViewController alloc]init];
    [self addchildVC:wode Andimage:[UIImage imageNamed:@"我的"] AndselectedImage:[UIImage imageNamed:@"我的选中"] Andtitle:@"我的"];
    
}

-(void)addchildVC:(UIViewController *)childVC Andimage:(UIImage *)image AndselectedImage:(UIImage *)selectedImage Andtitle:(NSString *)title
{
    // 设置标题
    childVC.title = title;
    // 设置图标
    childVC.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置选中图标
    childVC.tabBarItem.selectedImage= [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置字体
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    textAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    // 设置选中时的字体颜色
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1];
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateSelected];
    // 添加为tabbar控制器的子控制器
    if (childVC != _communityViewController) {
        nav_ViewController *navigationVC = [[nav_ViewController alloc] initWithRootViewController:childVC];
        [self addChildViewController:navigationVC];
    }else {
        [self addChildViewController:childVC];
    }   
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}



@end
