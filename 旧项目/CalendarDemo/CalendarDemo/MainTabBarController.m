//
//  MainTabBarController.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/20.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "MainTabBarController.h"

#import "ScheduleVC.h"
#import "TaskVC.h"
#import "DiscussVC.h"
#import "ContactsVC.h"
//>>>>>>>
#import "MainTabBar.h"//自定义tabbar
#import "OptionView.h"//中间的加号
#import "OptionView.h"//动画视图
#import "EditScheduleVC.h"//添加日程📅
#import "AddTomatoVC.h"//添加番茄🍅
#import "OptionVC3.h"
#import "OptionVC4.h"
#import "OptionVC5.h"
#import "OptionVC6.h"
#import "OptionVC7.h"
#import "OptionVC8.h"

@interface MainTabBarController ()<MainTabBarAgency,UITabBarDelegate,OptionViewDelegate>

@end

@implementation MainTabBarController
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    //添加所有的子控制器
    [self addAllChildVCs];
    //自定义tabbar
    MainTabBar *main_tabbar = [[MainTabBar alloc]init];
    //取消tabBar的透明效果
//    main_tabbar.translucent = NO;
    main_tabbar.agency = self;
    main_tabbar.delegate = self;
    // KVC：如果要修系统的某些属性，但被设为readOnly，就是用KVC，即setValue：forKey：。
    [self setValue:main_tabbar forKey:@"tabBar"];
}
//添加所有的子控制器
-(void)addAllChildVCs{
    //创建
    ScheduleVC *schedule_VC = [[ScheduleVC alloc]init];
    TaskVC *task_VC = [[TaskVC alloc]init];
    DiscussVC *discuss_VC = [[DiscussVC alloc]init];
    ContactsVC *contacts_VC = [[ContactsVC alloc]init];
    //添加
    [self addChildVC:schedule_VC title:@"日程" image:@"schedule_tabbar" selectedImage:@"schedule_hd_tabbar"];
    [self addChildVC:task_VC title:@"效率" image:@"task_tabbar" selectedImage:@"task_hd_tabbar"];
    [self addChildVC:discuss_VC title:@"讨论" image:@"discuss_tabbar" selectedImage:@"discuss_hd_tabbar"];
    [self addChildVC:contacts_VC title:@"微约录" image:@"contacts_tabbar" selectedImage:@"contacts_hd_tabbar"];
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
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor lightGrayColor]} forState:UIControlStateNormal];
    [childVC.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName : KRGB(52, 168, 238, 1.0)} forState:UIControlStateSelected];
    
    // 为子控制器包装导航控制器
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:childVC];
    navi.navigationBar.barTintColor = KRGB(52, 168, 238, 1.0);// 设置导航栏背景颜色
    [navi.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];// 设置导航栏文字字体大小 文字的颜色
    // 添加子控制器
    [self addChildViewController:navi];
}


#pragma mark -MainTabBarAgency
//点击centerBtn
-(void)clickCenterBtnEvent { 
    OptionView *optionView = [[OptionView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [KMyWindow addSubview:optionView];
    optionView.delegate = self;
    optionView.optionBtnArr = @[@{@"icon":@"schedule3_option",@"title":@"日程"},
                                @{@"icon":@"tomato_option",@"title":@"效率"},
                                @{@"icon":@"specialDay_option",@"title":@"纪念日"}];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [optionView show];
    });
}

#pragma mark -OptionViewDelegate
-(void)optionBtn1Action{
    EditScheduleVC *editSchedule_VC = [[EditScheduleVC alloc]init];
    editSchedule_VC.pushOrMode = @"mode";
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:editSchedule_VC];
    [self presentViewController:navi animated:YES completion:nil];
}
-(void)optionBtn2Action{
    AddTomatoVC *tomato_VC = [[AddTomatoVC alloc]init];
    tomato_VC.addOrEdit = @"add";
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:tomato_VC];
    [self presentViewController:navi animated:YES completion:nil];
}
-(void)optionBtn3Action{
    OptionVC3 *option_VC3 = [[OptionVC3 alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:option_VC3];
    [self presentViewController:navi animated:YES completion:nil];
}
-(void)optionBtn4Action{
    OptionVC4 *option_VC4 = [[OptionVC4 alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:option_VC4];
    [self presentViewController:navi animated:YES completion:nil];
}
-(void)optionBtn5Action{
    OptionVC5 *option_VC5 = [[OptionVC5 alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:option_VC5];
    [self presentViewController:navi animated:YES completion:nil];
}
-(void)optionBtn6Action{
    OptionVC6 *option_VC6 = [[OptionVC6 alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:option_VC6];
    [self presentViewController:navi animated:YES completion:nil];
}
-(void)optionBtn7Action{
    OptionVC7 *option_VC7 = [[OptionVC7 alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:option_VC7];
    [self presentViewController:navi animated:YES completion:nil];
}
-(void)optionBtn8Action{
    OptionVC8 *option_VC8 = [[OptionVC8 alloc]init];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:option_VC8];
    [self presentViewController:navi animated:YES completion:nil];
}


#pragma mark -didReceiveMemoryWarning
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
