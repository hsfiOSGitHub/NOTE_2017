//
//  nav_ViewController.m
//  友照
//
//  Created by ZX on 16/11/21.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "nav_ViewController.h"

@interface nav_ViewController ()

@end

@implementation nav_ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationBar.barTintColor = dao_hang_lan_Color;
    [self.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:20],
       NSForegroundColorAttributeName:[UIColor whiteColor]}];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
