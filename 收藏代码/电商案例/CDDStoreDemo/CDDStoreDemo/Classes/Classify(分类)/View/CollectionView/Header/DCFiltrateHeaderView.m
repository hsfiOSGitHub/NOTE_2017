//
//  DCFiltrateHeaderView.m
//  CDDMall
//
//  Created by apple on 2017/6/17.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//
#define FiltrateViewScreenW ScreenW * 0.7

#import "DCFiltrateHeaderView.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCFiltrateHeaderView ()

/* 标题 */
@property (strong , nonatomic)UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *arrowImageView;
@end

@implementation DCFiltrateHeaderView

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI
{
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = PFR15Font;
    [self addSubview:_titleLabel];
    
    _arrowImageView = [[UIImageView alloc] init];
    _arrowImageView.image = [UIImage imageNamed:@"goodsDetail_jiantou_xia"];
    _arrowImageView.userInteractionEnabled = YES;
    _arrowImageView.contentMode = UIViewContentModeCenter;
    [self addSubview:_arrowImageView];
    [_arrowImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sectionDidClick)]];
}

#pragma mark - 展开列表点击事件
- (void)sectionDidClick {
    
    [UIView animateWithDuration:0.25 animations:^{
         self.arrowImageView.transform = CGAffineTransformRotate(self.arrowImageView.transform, M_PI);
    }];
    
    !_sectionClick ? : _sectionClick();
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.frame = CGRectMake(5, DCMargin, 100, 35);
    
    _arrowImageView.frame = CGRectMake(FiltrateViewScreenW - 45, DCMargin, 35, 35);
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.titleLabel.text = title;
}


#pragma mark - Setter Getter Methods


@end
