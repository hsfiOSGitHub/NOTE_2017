//
//  CustomNavViewController.m
//  自定义导航
//
//  Created by 可可家里 on 2017/4/7.
//  Copyright © 2017年 可可家里. All rights reserved.
//

#import "CustomNavViewController.h"

@interface CustomNavViewController ()
@property(nonatomic,strong) id popDelegate;
@end

@implementation CustomNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //将系统的代理保存（在view 加载在完毕就赋值）
    self.popDelegate =self.interactivePopGestureRecognizer.delegate;
    
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    self.interactivePopGestureRecognizer.delegate = nil;
    if (self.viewControllers.count!=0)
    {
        viewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[self imageWithOriImageName:@"global_return_arrow"] style:0 target:self action:@selector(back)];
    }
    [super pushViewController:viewController animated:YES];
    
}
-(void)back
{
    [self popViewControllerAnimated:YES];
}

- (UIImage *)imageWithOriImageName:(NSString *)imageName
{
    //传入一张图片,返回一张不被渲染的图片
    UIImage *image = [UIImage imageNamed:imageName];
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}


#pragma mark - 实现代理方法
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSLog(@"代理方法的实现");
    //判断控制器是否为根控制器
    if (self.childViewControllers.count == 1) {
        //将保存的代理赋值回去,让系统保持原来的侧滑功能
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }
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
