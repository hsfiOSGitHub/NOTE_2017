//
//  ColorPickerView.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/12.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPickerView : UIView
{  
    CGPoint startPoint;  
} 

@property (nonatomic,strong) UIImageView *icon;
@property (nonatomic,strong) UIView *levelView;
@property (nonatomic,strong) UIButton *level1Btn;//尽兴娱乐
@property (nonatomic,strong) UIButton *level2Btn;//休息放松
@property (nonatomic,strong) UIButton *level3Btn;//高效工作
@property (nonatomic,strong) UIButton *level4Btn;//强迫工作
@property (nonatomic,strong) UIButton *level5Btn;//无效工作

-(void)open;
-(void)close;

@end
