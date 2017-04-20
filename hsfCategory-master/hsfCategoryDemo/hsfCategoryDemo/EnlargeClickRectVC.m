
//
//  EnlargeClickRectVC.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "EnlargeClickRectVC.h"

#import "UIButton+enlargeClickRect.h"

@interface EnlargeClickRectVC ()
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
//提示
@property (weak, nonatomic) IBOutlet UILabel *alertLabel;
@end

@implementation EnlargeClickRectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UIButton+enlargeClickRect";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // 扩大testBtn的点击范围
    [self.testBtn setEnlargeClickRectWithTop:100 right:100 bottom:100 left:100];
}
- (IBAction)testBtnACTION:(UIButton *)sender {
    [UIView animateWithDuration:0.8 animations:^{
        self.alertLabel.frame = CGRectMake(0, 0, self.alertLabel.frame.size.width, self.alertLabel.frame.size.height);
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.8 animations:^{
                self.alertLabel.frame = CGRectMake(0, -self.alertLabel.frame.size.height, self.alertLabel.frame.size.width, self.alertLabel.frame.size.height);
            }];
        });
    }];
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
