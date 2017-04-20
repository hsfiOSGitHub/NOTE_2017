//
//  KnTitleScrollView.m
//  SZB_doctor
//
//  Created by monkey2016 on 16/8/26.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "KnTitleScrollView.h"
#define btnW (KScreenWidth - 2)/4
#define btnH 40
#define lineH 2

@interface KnTitleScrollView ()

@end

@implementation KnTitleScrollView
////初始化方法
//-(instancetype)initWithFrame:(CGRect)frame{
//    self = [super initWithFrame: frame];
//    if (self) {
//        [self addBtnsWithTitleArray:self.titleArr];
//        [self addSubview:self.bottomLineView];
//    }
//    return self;
//}
-(void)setTitleArr:(NSArray *)titleArr{
    self.backgroundColor = [UIColor lightGrayColor];
    [self addBtnsWithTitleArray:titleArr];
}
//添加btns
-(void)addBtnsWithTitleArray:(NSArray *)titleArr{
    self.contentSize = CGSizeMake(btnW * titleArr.count, btnH);
    for (int i = 0; i < titleArr.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(btnW * i + i, 0, btnW, btnH);
        [btn setTitle:titleArr[i][@"name"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setBackgroundColor:KRGB(253, 254, 255, 1)];
        //添加点击事件
        [btn setTag:100 + i];
        btn.userInteractionEnabled = YES;
        [btn addTarget:self action:@selector(btnClickEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    //添加底线
    _baselineView = [[UIView alloc]initWithFrame:CGRectMake(0, btnH - lineH, btnW, lineH)];
    _baselineView.backgroundColor = KRGB(0, 172, 204, 1);
    [self addSubview:_baselineView];
    //第一个btn
    UIButton *oldBtn = [self viewWithTag:self.oldTag];
    [oldBtn setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
}
//btn添加点击事件
-(void)btnClickEvent:(UIButton *)sender{
    //判断滑动方向
    if (self.oldTag > sender.tag) {//向左滑动
        self.oldTag = sender.tag;
        [self.agency scrollLeft];
    }else if (self.oldTag < sender.tag){//向右滑动
        self.oldTag = sender.tag;
        [self.agency scrollRight];
    }
}
//懒加载oldTag
-(NSInteger)oldTag{
    if (_oldTag == 0) {
        _oldTag = 100;
    }
    return _oldTag;
}



@end
