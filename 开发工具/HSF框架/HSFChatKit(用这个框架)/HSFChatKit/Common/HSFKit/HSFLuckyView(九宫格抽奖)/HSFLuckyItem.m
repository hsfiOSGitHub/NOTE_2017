//
//  HSFLuckyItem.m
//  LuckyDemo
//
//  Created by JuZhenBaoiMac on 2017/7/20.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFLuckyItem.h"


@interface HSFLuckyItem ()

@property (nonatomic,strong) UIView *maskView;

//type
@property (nonatomic,strong) UIButton *btn;

@end

@implementation HSFLuckyItem
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //默认
        self.backgroundColor = [UIColor whiteColor];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.backgroundColor = [UIColor clearColor];
        self.btn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.btn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.btn];
        
        self.maskView = [[UIView alloc]init];
        self.maskView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.maskView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.maskView];
    }
    return self;
}

//setUp
-(void)setUp{
    [self.btn setImage:[UIImage imageNamed:self.source[@"image"]] forState:UIControlStateNormal];
    [self.btn setTitle:self.source[@"title"] forState:UIControlStateNormal];
    self.maskView.backgroundColor = self.maskViewColor;
}





@end
