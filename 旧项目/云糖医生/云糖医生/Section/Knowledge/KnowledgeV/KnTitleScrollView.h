//
//  KnTitleScrollView.h
//  SZB_doctor
//
//  Created by monkey2016 on 16/8/26.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentScrollAction <NSObject>
-(void)scrollLeft;//向左滑动
-(void)scrollRight;//向右滑动
@end

@interface KnTitleScrollView : UIScrollView
@property (nonatomic,strong) NSArray *titleArr;//标题数组
@property (nonatomic,strong) UIView *baselineView;//底部的线条
@property (nonatomic,assign) id<ContentScrollAction> agency;//设置代理
@property (nonatomic,assign) NSInteger oldTag;//上一个btn的tag值
//btn添加点击事件
-(void)btnClickEvent:(UIButton *)sender;
@end
