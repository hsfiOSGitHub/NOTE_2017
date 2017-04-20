//
//  TuiKuanCell4.m
//  ZXJiaXiao
//
//  Created by yujian on 16/6/20.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "TuiKuanCell4.h"

@implementation TuiKuanCell4

- (void)awakeFromNib
{
    [super awakeFromNib];
    _Btn1.layer.cornerRadius = 20;
    _Btn1.layer.masksToBounds = YES;
    _Btn1.layer.borderWidth = 2;
    _Btn1.layer.borderColor = YuYueSuccessColor.CGColor;
    
    _Btn2.layer.cornerRadius = 20;
    _Btn2.layer.masksToBounds = YES;
    _Btn2.layer.borderWidth = 2;
    _Btn2.layer.borderColor = YuYueSuccessColor.CGColor;
    
    _Btn3.layer.cornerRadius = 20;
    _Btn3.layer.masksToBounds = YES;
    _Btn3.layer.borderWidth = 2;
    _Btn3.layer.borderColor = YuYueSuccessColor.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
