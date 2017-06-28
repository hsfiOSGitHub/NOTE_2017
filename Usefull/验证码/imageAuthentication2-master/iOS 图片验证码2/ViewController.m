//
//  ViewController.m
//  iOS 图片验证码2
//
//  Created by tianXin on 16/3/18.
//  Copyright © 2016年 tianXin. All rights reserved.
//

#import "ViewController.h"
#import "PooCodeView/PooCodeView.h"

@interface ViewController ()
{
    PooCodeView *_pooCodeView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   _pooCodeView = [[PooCodeView alloc] initWithFrame:CGRectMake(50, 100, 82, 32)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_pooCodeView addGestureRecognizer:tap];
    [self.view addSubview:_pooCodeView];

}

- (void)tapClick:(UITapGestureRecognizer*)tap{
    [_pooCodeView changeCode];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
