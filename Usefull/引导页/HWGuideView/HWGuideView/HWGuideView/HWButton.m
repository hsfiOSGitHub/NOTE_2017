//
//  HWButton.m
//  HWGuideView
//
//  Created by Lee on 2017/3/31.
//  Copyright © 2017年 cashpie. All rights reserved.
//

#import "HWButton.h"

@implementation HWButton

+ (HWButton *)hw_buttonWithTitle:(NSString *)title titleColor:(UIColor *)color{
    HWButton * button = [HWButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.layer.cornerRadius = 5.0;
    button.layer.borderWidth = 1.0;
    button.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:14.0];
    button.layer.borderColor = [UIColor brownColor].CGColor;
    return button;
}

@end
