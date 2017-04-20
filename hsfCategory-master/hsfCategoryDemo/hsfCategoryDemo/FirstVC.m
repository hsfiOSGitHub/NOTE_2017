//
//  FirstVC.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/27.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "FirstVC.h"

#import "SecondVC.h"
#import "UIView+YGPulseView.h"

@interface FirstVC ()
@property (weak, nonatomic) IBOutlet UIView *testView;
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation FirstVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.testView startPulseWithColor:[UIColor redColor] animation:YGPulseViewAnimationTypeRadarPulsing];
    
    
    // 换行符：\n 不起作用
    self.testLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.testLabel.text = @"但是疯狂减肥后开始点击佛教佛佛教啊结束哦\n大煞风景福建省累计罚哦时间佛\n的身份告诉对方iiii附近开了多少积分大煞风景哦";
}
- (IBAction)pushToSecondVC:(UIButton *)sender {
    SecondVC *vc = [[SecondVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
