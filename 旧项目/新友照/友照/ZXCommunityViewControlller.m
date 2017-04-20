//
//  CommunityViewControlller.m
//  ZXJiaXiao
//
//  Created by ZX on 16/1/5.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXCommunityViewControlller.h"


@interface ZXCommunityViewControlller ()


@end

@implementation ZXCommunityViewControlller
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

#pragma mark Content Filtering


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
    // Dispose of any resources that can be recreated.
}

@end
