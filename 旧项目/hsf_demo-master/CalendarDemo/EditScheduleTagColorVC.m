//
//  EditScheduleTagColorVC.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/3.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "EditScheduleTagColorVC.h"

#import "WSColorImageView.h"

@interface EditScheduleTagColorVC ()
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation EditScheduleTagColorVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置按钮
    self.okBtn.layer.masksToBounds = YES;
    self.okBtn.layer.cornerRadius = 10;
    self.okBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.okBtn.layer.borderWidth = 1;
    
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.cornerRadius = 10;
    self.cancelBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    
    //色卡
    WSColorImageView *ws = [[WSColorImageView alloc]initWithFrame:self.colorView.bounds];
    ws.center = self.colorView.center;
    [self.colorView addSubview:ws];
    ws.currentColorBlock = ^(UIColor *color){
        [self.okBtn setBackgroundColor:color];
    };
    
}
//返回
- (IBAction)backBtnACTION:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击确认
- (IBAction)okBtnACTION:(UIButton *)sender {
    if ([sender.backgroundColor isEqual:[UIColor whiteColor]]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(changeTagColorAtIndex:withColor:)]) {
        [self.delegate changeTagColorAtIndex:self.currentTagIndex withColor:self.okBtn.backgroundColor];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}
//点击取消
- (IBAction)cancelBtnACTION:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
