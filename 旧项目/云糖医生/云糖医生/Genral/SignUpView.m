//
//  SZBAlertView1.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/19.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SignUpView.h"


@interface SignUpView ()

@end

@implementation SignUpView


//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (SignUpView *)[self loadNibView];
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
    _cancel.layer.masksToBounds = YES;
    _cancel.layer.cornerRadius = 5;
    [_cancel setBackgroundColor:[UIColor lightGrayColor]];
    [_cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _ok.layer.masksToBounds = YES;
    _ok.layer.cornerRadius = 5;
    [_ok setBackgroundColor:KRGB(20, 157, 192, 1)];
    [_ok setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
//配置数据
-(void)setContentDic:(NSDictionary *)contentDic{
    _contentDic = contentDic;
    self.title.text = contentDic[@"title"];
    self.message.text = contentDic[@"message"];
}
//绘制
- (void)drawRect:(CGRect)rect {
    [self setUpSubviews];
}
-(void)awakeFromNib{
    [self setUpSubviews];
}
//取消
- (IBAction)cancelEvent:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:SZBAlertView1Noti_cancel object:nil];
    
}
//确认
- (IBAction)okEvent:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:SZBAlertView1Noti_ok object:nil];
}





@end
