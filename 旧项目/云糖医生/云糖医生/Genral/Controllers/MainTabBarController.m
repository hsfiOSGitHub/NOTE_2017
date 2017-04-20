//
//  MainTabBarController.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/26.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "MainTabBarController.h"

@interface MainTabBarController ()<EMClientDelegate>

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    // 添加所有的子控制器
    [self addAllChildVcs];
}

//添加所有的子控制器
-(void)addAllChildVcs{
    //创建子控制器
    PatientManageViewController *PatientManage_VC = [[PatientManageViewController alloc]init];
    
    ProjectViewController *Project_VC = [[ProjectViewController alloc]init];
    SechedulingVC *sechdeuling_VC = [[SechedulingVC alloc]init];
    KnowledgeVC *knowledge_VC = [[KnowledgeVC alloc]init];
    MineVC *mine_VC = [[MineVC alloc]init];
    //图片
    UIImage *PatientManageImg = [UIImage imageNamed:@"患者管理"];
    UIImage *PatientManageImg_hd = [UIImage imageNamed:@"患者管理-选中"];
    
    UIImage *ProjectImg = [UIImage imageNamed:@"项目"];
    UIImage *ProjectImg_hd = [UIImage imageNamed:@"项目-选中"];
    
    UIImage *sechedulingImg = [UIImage imageNamed:@"排班"];
    UIImage *sechedulingImg_hd = [UIImage imageNamed:@"排班-选中"];
    
    UIImage *knowledgeImg = [UIImage imageNamed:@"知识"];
    UIImage *knowledgeImg_hd = [UIImage imageNamed:@"知识-选中"];
    
    UIImage *mineImg = [UIImage imageNamed:@"我的"];
    UIImage *mineImg_hd = [UIImage imageNamed:@"我的-选中"];
    //标题
    NSString *PatientManageTitle = @"患者管理";
    NSString *ProjectTitle = @"项目";
    NSString *sechedulingTitle = @"排班";
    NSString *knowledgeTitle = @"知识";
    NSString *mineTitle = @"我的";
   
    //添加
    [self addchildVC:PatientManage_VC Andimage:PatientManageImg AndselectedImage:PatientManageImg_hd Andtitle:PatientManageTitle];
    
    
    [self addchildVC:Project_VC Andimage:ProjectImg AndselectedImage:ProjectImg_hd Andtitle:ProjectTitle];
    [self addchildVC:sechdeuling_VC Andimage:sechedulingImg AndselectedImage:sechedulingImg_hd Andtitle:sechedulingTitle];
    [self addchildVC:knowledge_VC Andimage:knowledgeImg AndselectedImage:knowledgeImg_hd Andtitle:knowledgeTitle];
    [self addchildVC:mine_VC Andimage:mineImg AndselectedImage:mineImg_hd Andtitle:mineTitle];
}
-(void)addchildVC:(UIViewController *)childVC Andimage:(UIImage *)image AndselectedImage:(UIImage *)selectedImage Andtitle:(NSString *)title{
    // 设置标题
    childVC.title = title;
    // 设置图标
    childVC.tabBarItem.image = image;
    // 设置选中图标
    childVC.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置字体
    NSMutableDictionary *textAttrs =[NSMutableDictionary dictionary];
    //    textAttrs[NSFontAttributeName]=[UIFont systemFontOfSize:14];
    textAttrs[NSForegroundColorAttributeName]=[UIColor lightGrayColor];
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    // 设置选中时的字体颜色
    textAttrs[NSForegroundColorAttributeName] = KRGB(0, 172, 204, 1.0);
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateSelected];
    //tabBar 的背景颜色
    self.tabBar.barTintColor = [UIColor whiteColor];
    // 添加为tabBar控制器的子控制器
    UINavigationController *navigationVC=[[UINavigationController alloc]initWithRootViewController:childVC];
    navigationVC.navigationBar.barTintColor = KRGB(0, 172, 204, 1.0);
    // 设置导航栏文字的颜色
    [navigationVC.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self addChildViewController:navigationVC];
    
    
}

- (void)didLoginFromOtherDevice
{
    [ZXUD removeObjectForKey:@"IS_LOGIN"];
    [ZXUD removeObjectForKey:@"userpic"];
    [ZXUD removeObjectForKey:@"username"];
    [ZXUD removeObjectForKey:@"phoneNum"];
    [ZXUD setObject:nil forKey:@"ident_code"];
    [ZXUD synchronize];
    LoginVC *VC = [[LoginVC alloc] init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:VC];
    VC.hidesBottomBarWhenPushed=YES;
    [self presentViewController:navi animated:YES completion:nil];
    [MBProgressHUD showSuccess:@"当前账号已在其他设备登录。"];
}

//徽章设置
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    item.badgeValue = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
