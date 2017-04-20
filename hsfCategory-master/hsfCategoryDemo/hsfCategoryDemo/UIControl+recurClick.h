//
//  UIControl+recurClick.h
//  主要解决按钮的重复点击问题
//
//  Created by King on 16/9/2.
//  Copyright © 2016年 King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (recurClick)
@property (nonatomic, assign) NSTimeInterval uxy_acceptEventInterval;
@property (nonatomic, assign)BOOL uxy_ignoreEvent;
@end
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const void *BandNameKey = &BandNameKey;


//用法
//UIButton *button  = [[ UIButton alloc] init];
//button.uxy_acceptEventInterval = 3.0;
//[button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
