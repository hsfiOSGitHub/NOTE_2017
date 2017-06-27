//
//  ViewController.m
//  MTCustomCountDownView
//
//  Created by acmeway on 2017/5/18.
//  Copyright © 2017年 acmeway. All rights reserved.
//

#import "ViewController.h"
#import "MGSecondViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button2 = [[UIButton alloc ] initWithFrame: CGRectMake(80, 100, self.view.bounds.size.width - 2 * 80, 50)];
    
    [button2 setTitle:@"开始" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:button2];
    
    [button2 addTarget:self action:@selector(clickNextView:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (IBAction)clickNextView:(UIButton *)sender {
    
    MGSecondViewController *secondVC = [[MGSecondViewController alloc] init];
    
    [self.navigationController pushViewController:secondVC animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
