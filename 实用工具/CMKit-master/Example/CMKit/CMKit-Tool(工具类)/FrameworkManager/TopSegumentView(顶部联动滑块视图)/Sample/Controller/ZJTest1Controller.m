//
//  ZJTest1Controller.m
//  ZJScrollPageView
//
//  Created by ZeroJ on 16/6/30.
//  Copyright © 2016年 ZeroJ. All rights reserved.
//

#import "ZJTest1Controller.h"
//#import "ZJScrollPageView/ZJScrollPageView.h"
@interface ZJTest1Controller ()

@end

@implementation ZJTest1Controller
- (IBAction)testBtnOnClick:(UIButton *)sender {

    if (_click) {
        _click();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *testBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    testBtn.backgroundColor = [UIColor whiteColor];
    [testBtn setTitle:@"点击" forState:UIControlStateNormal];
    [testBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [testBtn addTarget:self action:@selector(testBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:testBtn];}

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
