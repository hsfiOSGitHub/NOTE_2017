//
//  HSFRefreshAutoGifFooter.m
//  友照
//
//  Created by monkey2016 on 16/12/6.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "HSFRefreshAutoGifFooter.h"

@implementation HSFRefreshAutoGifFooter

#pragma mark - 重写父类的方法
- (void)prepare{
    [super prepare];

    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_car%d", i]];
        [refreshingImages addObject:image];
    }
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    //隐藏状态
//    self.refreshingTitleHidden = YES;
}

@end
