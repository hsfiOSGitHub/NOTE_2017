//
//  HSFTagView.m
//  HCJ
//
//  Created by JuZhenBaoiMac on 2017/7/10.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFTagView.h"

#import "NSString+Size.h"

#define k_space_H 10  //水平间距
#define k_space_V 10  //垂直间距
#define k_tagHeight 40  //tag高度


@interface HSFTagView ()

@property (nonatomic,strong) NSMutableArray *tagViewArr;//用来装btn对象

@end

@implementation HSFTagView

//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //默认
        self.backgroundColor = [UIColor whiteColor];
        self.tagColor = [UIColor blackColor];
        self.tagBgColor = [UIColor orangeColor];
        self.font = 15;
    }
    return self;
}

//配置
-(void)setUp{
    
    CGFloat w = 0.0;
    CGFloat h = k_tagHeight;
    CGFloat x = k_space_H;
    CGFloat y = k_space_V;
    
    for (int i = 0; i < self.tagsArr.count; i++) {
        NSString *title = self.tagsArr[i];
        CGSize size = [NSString sizeWithString:title font:[UIFont systemFontOfSize:self.font] maxSize:CGSizeMake(MAXFLOAT, h)];
        w = size.width + 20;
        
        if ((x + k_space_H*2 + w) > kScreenWidth) {
            x = k_space_H;
            y += (k_space_V + h);
        }
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(x, y, w, h);
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:self.tagColor forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:self.font];
        btn.backgroundColor = self.tagBgColor;
        [btn setTag:i];
        [btn addTarget:self action:@selector(clickTag:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.tagViewArr addObject:btn];
        
        x += (k_space_H + w);
    }
    
    //更改self的frame
    self.frame = CGRectMake(self.x, self.y, self.width, y + (k_space_V*2 + h));
}
//点击tag
-(void)clickTag:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(didSeleteTag:atIndex:)]) {
        [self.delegate didSeleteTag:self atIndex:sender.tag];
    }
}

//添加边框圆角
-(void)setTagCornerRadius:(CGFloat)cornerRadius borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    [self.tagViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = (UIButton *)obj;
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = cornerRadius;
        btn.layer.borderColor = borderColor.CGColor;
        btn.layer.borderWidth = borderWidth;
    }];
}


#pragma mark -懒加载
-(NSMutableArray *)tagViewArr{
    if (!_tagViewArr) {
        _tagViewArr = [NSMutableArray array];
    }
    return _tagViewArr;
}


@end
