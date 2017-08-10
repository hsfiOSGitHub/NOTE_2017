//
//  HSFBar.m
//  UserfullUIKit
//
//  Created by JuZhenBaoiMac on 2017/6/16.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFBar.h"

@interface HSFBar ()

@property (nonatomic,strong) UIView *baseline;
@property (nonatomic,strong) NSMutableArray *btnArr;

@end

@implementation HSFBar

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //默认
        self.backgroundColor = [UIColor whiteColor];
        
        self.isHavePaddingView = NO;
        self.paddingViewColor = [UIColor lightGrayColor];
        self.paddingInsert = 0;
        
        self.isHaveBaseline = NO;
        self.baselineColor = [UIColor redColor];
        self.baselineInsert = 0;
        
        self.currentSeleteIndex = 0;
    }
    return self;
}

//在最后，必须要实现的方法
-(void)setUp{
    CGFloat w = 0;
    CGFloat h = self.frame.size.height;
    if (self.isHavePaddingView) {
        w = (self.frame.size.width - (self.itemsArr.count - 1) * k_padding_width)/self.itemsArr.count;
    }else{
        w = (self.frame.size.width - (self.itemsArr.count - 1) * 0)/self.itemsArr.count;
    }
    
    for (int i = 0; i < self.itemsArr.count; i++) {
        //btn
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = 0;
        CGFloat y = 0;
        
        if (self.isHavePaddingView) {
            x = (w + k_padding_width)*i;
        }else{
            x = (w + 0)*i;
        }
        
        btn.frame = CGRectMake(x, y, w, h);
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitleColor:self.titleNorColor forState:UIControlStateNormal];
        
        NSString *title = self.itemsArr[i][@"title"];
        NSString *imgName = self.itemsArr[i][@"icon"];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        
        [btn setTag:(10000 + i)];
        [btn addTarget:self action:@selector(clickItemACTION:) forControlEvents:UIControlEventTouchUpInside];
        
        //paddingView
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), self.paddingInsert, k_padding_width, CGRectGetHeight(btn.frame) - 2*self.paddingInsert)];
        paddingView.backgroundColor = self.paddingViewColor;
        
        [self addSubview:btn];
        [self.btnArr addObject:btn];
        
        if (i < self.itemsArr.count - 1) {
            [self addSubview:paddingView];
        }
    }
    //添加baseline
    if (self.isHaveBaseline) {
        UIButton *btn = self.btnArr[self.currentSeleteIndex];
        self.baseline.frame = CGRectMake(btn.x + self.baselineInsert, self.height - self.baselineHeight, btn.width - 2*self.baselineInsert, self.baselineHeight);
        self.baseline.backgroundColor = self.baselineColor;
        [self addSubview:self.baseline];
    }
}

//点击item
-(void)clickItemACTION:(UIButton *)sender{
    NSInteger index = sender.tag - 10000;
    self.currentSeleteIndex = index;
    //移动baseline
    if (self.isHaveBaseline) {
        [UIView animateWithDuration:0.2 animations:^{
            UIButton *btn = self.btnArr[self.currentSeleteIndex];
            self.baseline.frame = CGRectMake(btn.x + self.baselineInsert, self.height - self.baselineHeight, btn.width - 2*self.baselineInsert, self.baselineHeight);
        }];
    }
    //代理事件
    if ([self.delegate respondsToSelector:@selector(clickItemAtIndex:)]) {
        [self.delegate clickItemAtIndex:index];
    }
}


#pragma mark -懒加载
-(UIView *)baseline{
    if (!_baseline) {
        _baseline = [[UIView alloc]init];
    }
    return _baseline;
}

-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}



@end
