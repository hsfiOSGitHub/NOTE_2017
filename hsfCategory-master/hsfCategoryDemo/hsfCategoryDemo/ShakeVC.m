//
//  ShakeVC.m
//  hsfCategoryDemo
//
//  Created by monkey2016 on 17/2/24.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ShakeVC.h"

#import "UIView+Shaking.h"

@interface ShakeVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *testBtn;
@property (weak, nonatomic) IBOutlet UITextField *testTF;

@end

@implementation ShakeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"UIView+Shaking";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.testTF.delegate = self;
    
    //添加点击手势 点击空白回收键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapACTION:)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:tap];
}
-(void)tapACTION:(UITapGestureRecognizer *)sender{
    [self.view endEditing:YES];
}

#pragma mark -UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (self.testTF.text.length > 10) {
        //抖动
        [self.testTF shakeWithTimes:6 speed:0.05 range:5 shakeDirection:ShakingDirectionVertical];
        return NO;
    }else{
        return YES;
    }
}

- (IBAction)testBtnACTION:(UIButton *)sender {
    //抖动
    [self.testBtn shakeWithTimes:20 speed:0.05 range:10 shakeDirection:ShakingDirectionHorizontal];
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
