//
//  HSFBar.m
//  UserfullUIKit
//
//  Created by JuZhenBaoiMac on 2017/6/16.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFBar.h"

@implementation HSFBar
//类方法
+(instancetype)barWithFrame:(CGRect)frame delegate:(id<HSFBarDelegate>)delegate itemsArr:(NSArray *)itemsArr titleNorColor:(UIColor *)titleNorColor titleHdColor:(UIColor *)titleHdColor isHavePaddingView:(BOOL)ishave paddingViewColor:(UIColor *)paddingColor paddingInsert:(CGFloat)paddingInsert{
    
    HSFBar *bar = [[HSFBar alloc]initWithFrame:frame];
    bar.backgroundColor = [UIColor whiteColor];
    bar.delegate = delegate;
    
    CGFloat w = 0;
    CGFloat h = frame.size.height;
    if (ishave) {
        w = (frame.size.width - (itemsArr.count - 1) * k_padding_width)/itemsArr.count;
    }else{
        w = (frame.size.width - (itemsArr.count - 1) * 0)/itemsArr.count;
    }
    
    for (int i = 0; i < itemsArr.count; i++) {
        //btn
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = 0;
        CGFloat y = 0;
        
        if (ishave) {
            x = (w + k_padding_width)*i;
        }else{
            x = (w + 0)*i;
        }
        
        btn.frame = CGRectMake(x, y, w, h);
        btn.backgroundColor = [UIColor clearColor];
        btn.titleLabel.font = [UIFont systemFontOfSize:17];
        [btn setTitleColor:titleNorColor forState:UIControlStateNormal];
        
        NSString *title = itemsArr[i][@"title"];
        NSString *imgName = itemsArr[i][@"icon"];
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        
        [btn setTag:(10000 + i)];
        [btn addTarget:self action:@selector(clickItemACTION:) forControlEvents:UIControlEventTouchUpInside];
        
        //paddingView
        UIView *paddingView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), paddingInsert, k_padding_width, CGRectGetHeight(btn.frame) - 2*paddingInsert)];
        paddingView.backgroundColor = paddingColor;
        
        [bar addSubview:btn];
        if (i < itemsArr.count - 1) {
            [bar addSubview:paddingView];
        }
    }

    return bar;
}
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

//点击item
-(void)clickItemACTION:(UIButton *)sender{
    NSInteger index = sender.tag - 10000;
    if ([self.delegate respondsToSelector:@selector(clickItemAtIndex:)]) {
        [self.delegate clickItemAtIndex:index];
    }
}




@end
