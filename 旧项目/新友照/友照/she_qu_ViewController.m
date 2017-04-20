//
//  she_qu_ViewController.m
//  友照
//
//  Created by ZX on 16/11/18.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "she_qu_ViewController.h"

@interface she_qu_ViewController ()

@end

@implementation she_qu_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"社区";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(userEdit)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
   
}

- (void)userEdit{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
