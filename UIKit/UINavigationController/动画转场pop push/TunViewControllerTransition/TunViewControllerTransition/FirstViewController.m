//
//  FirstViewController.m
//  TunViewControllerTransition
//
//  Created by 涂育旺 on 2017/7/15.
//  Copyright © 2017年 Qianhai Jiutong. All rights reserved.
//

#import "FirstViewController.h"
#import "UIViewController+TunTransition.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.circleTransition) {
        [self animateCircleInverseTransition];
    }else if(self.pageTransition)
    {
        [self animatePageInverseTransition];
    }else
    {
        [self animateInverseTransition];
    }
}

@end
