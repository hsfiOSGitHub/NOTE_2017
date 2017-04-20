//
//  SZBAlertView6.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/22.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "NameView.h"
#import "ValueHelper.h"

@implementation NameView
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (NameView *)[self loadNibView];
        self.frame = frame;
        [self setUpSubviews];
    }
    return self;
}
//获取到xib中的View
-(UIView *)loadNibView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return views.firstObject;
}
-(void)setUpSubviews{
    //配置self
    self.backgroundColor = [UIColor whiteColor];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    //配置按钮、
    _cancelBtn.layer.masksToBounds = YES;
    _cancelBtn.layer.cornerRadius = 5;
    [_cancelBtn setBackgroundColor:[UIColor lightGrayColor]];
    [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _okBtn.layer.masksToBounds = YES;
    _okBtn.layer.cornerRadius = 5;
    [_okBtn setBackgroundColor:KRGB(0, 172, 204, 1)];
    [_okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //配置textField
    self.nameTF.delegate = self;
}
//绘制
- (void)drawRect:(CGRect)rect {
    [self setUpSubviews];
}
-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUpSubviews];
}
//取消
- (IBAction)cancelEvent:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NameView_cancel_noti object:nil];
}
//确认
- (IBAction)okEvent:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:NameView_ok_noti object:nil userInfo:@{@"name":self.nameTF.text}];
}

#pragma mark -UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}






@end
