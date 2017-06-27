//
//  HSFSwitch_text.h
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/26.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSFSwitch_text : UIView

@property (nonatomic,strong) UIColor *color_off;
@property (nonatomic,strong) UIColor *color_on;

//类方法
+(instancetype)switchWithFrame:(CGRect)frame offText:(NSString *)offText onText:(NSString *)onText offColor:(UIColor *)offColor onColor:(UIColor *)onColor;


//打开
-(void)open;
//关闭
-(void)close;


@end
