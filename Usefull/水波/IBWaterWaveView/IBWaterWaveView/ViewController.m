//
//  ViewController.m
//  IBWaterWaveView
//
//  Created by iBlocker on 2017/8/22.
//  Copyright © 2017年 iBlocker. All rights reserved.
//

#import "ViewController.h"
#import "IBWaterWaveView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = IBHexColor(0xfafbff);
    
    IBWaterWaveView *waterView = [[IBWaterWaveView alloc] initWithFrame:(CGRect){0, 0, CGRectGetWidth(self.view.bounds), 228} startColor:IBHexColorA(0xfbd49d, 0.7) endColor:IBHexColorA(0xff785c, 0.7)];
    [self.view addSubview:waterView];
    
    IBWaterWaveView *waterView2 = [[IBWaterWaveView alloc] initWithFrame:(CGRect){0, 300, CGRectGetWidth(self.view.bounds), 228} startColor:IBHexColorA(0x90cfed, 0.3) endColor:IBHexColorA(0x21e2aa, 0.7)];
    [self.view addSubview:waterView2];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
