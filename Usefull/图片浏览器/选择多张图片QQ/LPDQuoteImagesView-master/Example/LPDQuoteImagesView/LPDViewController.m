//
//  LPDViewController.m
//  LPDQuoteImagesView
//
//  Created by Assuner-Lee on 02/17/2017.
//  Copyright (c) 2017 Assuner-Lee. All rights reserved.
//

#import "LPDViewController.h"
#import "LPDQuoteImagesView.h"
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

@interface LPDViewController () <LPDQuoteImagesViewDelegate>

@end

@implementation LPDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    LPDQuoteImagesView *view1 = [[LPDQuoteImagesView alloc] initWithFrame:CGRectMake(150, 30, 60, 60) withCountPerRowInView:1 cellMargin:0];
    view1.navcDelegate = self;
    view1.maxSelectedCount = 1;
    [self.view addSubview:view1];
    
    LPDQuoteImagesView *view2 = [[LPDQuoteImagesView alloc] initWithFrame:CGRectMake(0, 100, RELATIVE_VALUE(220), RELATIVE_VALUE(70)) withCountPerRowInView:3 cellMargin:12];
    view2.collectionView.scrollEnabled = NO;
    view2.navcDelegate = self;
    view2.maxSelectedCount = 3;
    [self.view addSubview:view2];
    
    LPDQuoteImagesView *view3 = [[LPDQuoteImagesView alloc] initWithFrame:CGRectMake(0, 250, SCREEN_WIDTH, 600) withCountPerRowInView:5 cellMargin:15];
    view3.navcDelegate = self;
    view3.maxSelectedCount = 24;
    [self.view addSubview:view3];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
