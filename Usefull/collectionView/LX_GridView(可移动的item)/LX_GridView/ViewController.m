//
//  ViewController.m
//  LX_GridView
//
//  Created by chuanglong02 on 16/9/21.
//  Copyright © 2016年 漫漫. All rights reserved.
//

#import "ViewController.h"

#import "LXAlipayViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    LxButton *button =[LxButton LXButtonWithTitle:@"点我" titleFont:[UIFont systemFontOfSize:16.0] Image:nil backgroundImage:nil backgroundColor:nil titleColor:[UIColor blackColor] frame:CGRectMake(20, 100, 100, 40)];
    [self.view addSubview:button];
    __weak ViewController *weakSelf = self;
    [button addClickBlock:^(UIButton *button) {
        LXAlipayViewController *lxalipay =[[LXAlipayViewController alloc]init];
        [weakSelf.navigationController pushViewController:lxalipay animated:YES];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
