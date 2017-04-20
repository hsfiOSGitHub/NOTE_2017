//
//  ZXSeconBaseViewController.m
//  ZXJiaXiao
//
//  Created by ZX on 16/3/22.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXSeconBaseViewController.h"
#import "tab_ViewController.h"
@interface ZXSeconBaseViewController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>
@end
//二级视图控制器的父类
@implementation ZXSeconBaseViewController

-(instancetype)init
{
    if (self = [super init])
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = dao_hang_lan_Color;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"fanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleDone target:self action:@selector(goToBack)];
    self.view.backgroundColor = ZX_BG_COLOR;
}


-(void)viewWillDisappear:(BOOL)animated
{
    [_animationView removeFromSuperview];
}


- (void)goToBack
{
    [self dismissViewControllerAnimated:NO completion:nil];

    if (self.navigationController.viewControllers.count == 1) {//堆栈里只有一个控制器的时候无法正退出
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
