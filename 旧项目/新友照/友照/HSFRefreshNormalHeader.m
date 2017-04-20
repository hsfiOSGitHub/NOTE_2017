//
//  HSFRefreshNormalHeader.m
//  友照
//
//  Created by monkey2016 on 16/12/6.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "HSFRefreshNormalHeader.h"

@implementation HSFRefreshNormalHeader

#pragma mark - 重写父类的方法
- (void)prepare{
    [super prepare];
    
    //所有的自定义东西都放在这里
    [self setTitle:@"普通闲置状态" forState:MJRefreshStateIdle];//普通闲置状态
    [self setTitle:@"松开就可以进行刷新的状态" forState:MJRefreshStatePulling];//松开就可以进行刷新的状态
    [self setTitle:@"正在刷新中的状态" forState:MJRefreshStateRefreshing];//正在刷新中的状态
    [self setTitle:@"即将刷新的状态" forState:MJRefreshStateWillRefresh];//即将刷新的状态
    [self setTitle:@"所有数据加载完毕，没有更多的数据了" forState:MJRefreshStateNoMoreData];//所有数据加载完毕，没有更多的数据了
    //一些其他属性设置
    /*
     // 设置字体
     self.stateLabel.font = [UIFont systemFontOfSize:15];
     self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:14];
     
     // 设置颜色
     self.stateLabel.textColor = [UIColor redColor];
     self.lastUpdatedTimeLabel.textColor = [UIColor blueColor];
     // 隐藏时间
     self.lastUpdatedTimeLabel.hidden = YES;
     // 隐藏状态
     self.stateLabel.hidden = YES;
     // 设置自动切换透明度(在导航栏下面自动隐藏)
     self.automaticallyChangeAlpha = YES;
     */
}

//如果需要自己重新布局子控件
- (void)placeSubviews{
    [super placeSubviews];
    
    //如果需要自己重新布局子控件，请在这里设置
    //箭头
    //    self.arrowView.center =
}

@end
