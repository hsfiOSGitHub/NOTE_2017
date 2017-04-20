//
//  MainTabBar.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/21.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "MainTabBar.h"

@interface MainTabBar ()

@property (nonatomic,strong) UIButton *centerBtn;

@end

@implementation MainTabBar
//初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.centerBtn setBackgroundImage:[UIImage imageNamed:@"center_tabbar"] forState:UIControlStateNormal];
        [self.centerBtn setBackgroundImage:[UIImage imageNamed:@"center_tabbar"] forState:UIControlStateHighlighted];
        [self.centerBtn setImage:[UIImage imageNamed:@"center_hd_tabbar"] forState:UIControlStateNormal];
        [self.centerBtn setImage:[UIImage imageNamed:@"center_hd_tabbar"] forState:UIControlStateHighlighted];
        
        self.centerBtn.size = self.centerBtn.currentBackgroundImage.size;
//        self.centerBtn.size = CGSizeMake(45, 45);
        [self.centerBtn addTarget:self action:@selector(centerBtnACTION:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.centerBtn];
    }
    return self;
}

/**
 *  加号按钮点击
 */
- (void)centerBtnACTION:(UIButton *)sender {
    // 通知代理
    if ([self.agency respondsToSelector:@selector(clickCenterBtnEvent)]) {
        [self.agency clickCenterBtnEvent];
    }
}

/**
 *  想要重新排布系统控件subview的布局，推荐重写layoutSubviews，在调用父类布局后重新排布。
 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 1.设置加号按钮的位置
    self.centerBtn.centerX = self.width*0.5;
    if (self.centerBtn.size.height > self.height) {
        self.centerBtn.centerY = self.height*0.5 - (self.centerBtn.size.height - self.height)/2;
    }else{
        self.centerBtn.centerY = self.height*0.5;
    }
    
    // 2.设置其他tabbarButton的frame
    CGFloat tabBarButtonW = self.width / 5;
    CGFloat tabBarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置x
            child.x = tabBarButtonIndex * tabBarButtonW;
            // 设置宽度
            child.width = tabBarButtonW;
            // 增加索引
            tabBarButtonIndex++;
            if (tabBarButtonIndex == 2) {
                tabBarButtonIndex++;
            }
        }
    }
}

@end
