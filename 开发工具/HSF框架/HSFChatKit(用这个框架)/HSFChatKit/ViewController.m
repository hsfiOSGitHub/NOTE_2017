//
//  ViewController.m
//  HSFChatKit
//
//  Created by JuZhenBaoiMac on 2017/8/18.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "ViewController.h"



@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *img;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *originImg = [UIImage imageNamed:@"meizi"];
    UIImage *maskImg = [UIImage imageNamed:@"camera"];
    
//    [self.img addCenterMotionEffectsXYWithOffset:100];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
