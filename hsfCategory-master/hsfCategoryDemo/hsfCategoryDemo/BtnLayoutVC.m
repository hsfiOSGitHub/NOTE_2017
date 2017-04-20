//
//  BtnLayoutVC.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/23.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "BtnLayoutVC.h"

#import "UIButton+Layout.h"

@interface BtnLayoutVC ()
@property (weak, nonatomic) IBOutlet UIButton *btn1;
@property (weak, nonatomic) IBOutlet UIButton *btn2;
@property (weak, nonatomic) IBOutlet UIButton *btn3;
@property (weak, nonatomic) IBOutlet UIButton *btn4;

@end

@implementation BtnLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"UIButton+Layout";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    
    // image在上，label在下
    [self.btn1 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:10];
    
    // image在下，label在上
    [self.btn2 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleBottom imageTitleSpace:10];
    
    // image在左，label在右
    [self.btn3 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleLeft imageTitleSpace:10];
    
    // image在右，label在左
    [self.btn4 layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleRight imageTitleSpace:10];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
