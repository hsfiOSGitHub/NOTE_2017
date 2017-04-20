//
//  CustomKeyboardInputView.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/27.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "CustomKeyboardInputView.h"

@implementation CustomKeyboardInputView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self = (CustomKeyboardInputView *)[self loadNibView];
        self.frame = frame;
    }
    return self;
}
//获取到xib中的View
-(UIView *)loadNibView{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
    return views.firstObject;
}

#pragma mark -awakeFromNib
-(void)awakeFromNib{
    [super awakeFromNib];

}
//监听
//选择时间
- (IBAction)getYouChoosedDate:(UIDatePicker *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kCustomKeyboardInputView" object:nil userInfo:@{@"youChoosedDate":sender.date}];
}
//点击确认
- (IBAction)okBtnACTION:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kKeyboardOkBtn" object:nil userInfo:@{@"okBtnDate":_datePicker.date}];
}



//配置subviews

@end
