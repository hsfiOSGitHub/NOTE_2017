//
//  HSFProgressView.h
//  HSFProgressViewDemo
//
//  Created by JuZhenBaoiMac on 2017/7/12.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSFProgressView : UIView

@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,assign) CGFloat progressViewHeight;
@property (nonatomic,strong) UIColor *minColor;
@property (nonatomic,strong) UIColor *maxColor;
@property (nonatomic,assign) CGFloat progress;//0~1

-(void)setUp;//配置
-(void)addView:(UIView *)view atProgress:(CGFloat)progress;//添加view
-(void)setCorner;//圆角

@end
