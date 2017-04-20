//
//  HSFRefreshGifHeader.m
//  友照
//
//  Created by monkey2016 on 16/12/6.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "HSFRefreshGifHeader.h"

@implementation HSFRefreshGifHeader

#pragma mark - 重写父类的方法
- (void)prepare{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (int i = 1; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_car%d", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *pullingImages = [NSMutableArray array];
    for (int i = 1; i < 2; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_car%d", i]];
        [pullingImages addObject:image];
    }
    [self setImages:pullingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (int i = 1; i < 5; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"refresh_car%d", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
    
    //隐藏时间
//    self.lastUpdatedTimeLabel.hidden = YES;
    //隐藏状态
//    self.stateLabel.hidden = YES;
}


@end
