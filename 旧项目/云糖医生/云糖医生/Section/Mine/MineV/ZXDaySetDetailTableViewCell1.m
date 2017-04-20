//
//  ZXDaySetDetailTableViewCell1.m
//  ZXCoachApp
//
//  Created by Finsen on 16/5/25.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXDaySetDetailTableViewCell1.h"
@implementation ZXDaySetDetailTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
     UIView *backgroundview1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 216)];
    //添加日期选择器
    self.datePicker = [[UUDatePicker alloc]initWithframe:CGRectMake(0, 0, KScreenWidth,  216 *3/4) PickerStyle:UUDateStyle_YearMonthDay didSelected:^(NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        _SetTextField.text = [NSString stringWithFormat:@"%@-%@-%@",year,month,day];
    }];
    [backgroundview1 addSubview:self.datePicker];
    UIView *V = [[UIView alloc]initWithFrame:CGRectMake(0, 216 *3/4, KScreenWidth, 216/4)];
    V.backgroundColor = [UIColor lightGrayColor];
    self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btn.frame = CGRectMake(0, 1, KScreenWidth, 216/4-2);
    [self.btn setTitle:@"确认" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btn.backgroundColor =  KRGB(0, 172, 204, 1.0);
    [V addSubview:self.btn];
    [backgroundview1 addSubview:V];
    _SetTextField.inputView = backgroundview1;
    
    //文本框颜色
//    _SetTextField.layer.borderColor = [UIColor lightGrayColor].CGColor; // set color as you want.
//    _SetTextField.layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
