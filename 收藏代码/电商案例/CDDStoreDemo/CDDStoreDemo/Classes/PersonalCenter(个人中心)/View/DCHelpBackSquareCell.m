//
//  DCHelpBackSquareCell.m
//  CDDMall
//
//  Created by apple on 2017/6/4.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCHelpBackSquareCell.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCHelpBackSquareCell ()


@end

@implementation DCHelpBackSquareCell

#pragma mark - Intial
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpUI];
    }
    return self;
}

#pragma mark - UI
- (void)setUpUI
{
    self.backgroundColor = [UIColor whiteColor];
    _squareImageView = [[UIImageView alloc] init];
    _squareImageView.contentMode = UIViewContentModeScaleAspectFit; //自适应
    [self addSubview:_squareImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = PFR14Font;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor darkGrayColor];
    [self addSubview:_titleLabel];
}

#pragma mark - 布局
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_squareImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(self)setOffset:DCMargin *3];
        make.size.mas_equalTo(CGSizeMake(self.dc_width - DCMargin *8, self.dc_width - DCMargin *8));
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        [make.top.mas_equalTo(_squareImageView.mas_bottom)setOffset:DCMargin];
    }];
    
}

#pragma mark - Setter Getter Methods


@end
