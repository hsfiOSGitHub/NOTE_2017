//
//  CircleProgressView.h
//  yuntangyi
//
//  Created by yuntangyi on 16/9/18.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView
//中心颜色
@property (strong, nonatomic)UIColor *centerColor;
//圆环背景色
@property (strong, nonatomic)UIColor *arcBackColor;
//圆环色
@property (strong, nonatomic)UIColor *arcFinishColor;
@property (strong, nonatomic)UIColor *arcUnfinishColor;
//百分比数值（0-1）
@property (assign, nonatomic)float percent;
//圆环宽度
@property (assign, nonatomic)float width;
//中间label的text
@property (nonatomic, strong) NSString *title;
@property (assign, nonatomic) CGFloat fontSize;
@property (nonatomic, strong) UIColor *titleColor;

@end
