//
//  HSFBaseVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/20.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "HSFBaseVC.h"

@interface HSFBaseVC ()

@end

@implementation HSFBaseVC
//初始化方法
-(instancetype)init{
    if (self = [super init]) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
#pragma mark -viewWillAppear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

#pragma mark -didReceiveMemoryWarning
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
