//
//  ArcCenterViewController.m
//  UIBezierPathMethods
//
//  Created by 劉光軍 on 2016/11/8.
//  Copyright © 2016年 劉光軍. All rights reserved.
//

#import "ArcCenterViewController.h"
#import "ArcCenterView.h"

@interface ArcCenterViewController ()

@end

@implementation ArcCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ArcCenterView *arcCenter = [[ArcCenterView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    arcCenter.backgroundColor = [UIColor blueColor];
    [self.view addSubview:arcCenter];
    
    // Do any additional setup after loading the view.
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
