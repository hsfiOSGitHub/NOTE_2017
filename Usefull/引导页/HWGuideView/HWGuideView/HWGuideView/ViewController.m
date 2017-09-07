//
//  ViewController.m
//  HWGuideView
//
//  Created by Lee on 2017/3/30.
//  Copyright © 2017年 cashpie. All rights reserved.
//

#import "ViewController.h"
#import "HWGuideView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    HWGuideView * guideView = [[HWGuideView alloc]initWithFrame:self.view.bounds];
    guideView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:guideView];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
