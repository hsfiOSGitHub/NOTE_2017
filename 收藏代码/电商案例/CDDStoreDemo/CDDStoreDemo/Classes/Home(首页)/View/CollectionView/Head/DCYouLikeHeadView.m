//
//  DCYouLikeHeadView.m
//  CDDMall
//
//  Created by apple on 2017/6/5.
//  Copyright © 2017年 RocketsChen. All rights reserved.
//

#import "DCYouLikeHeadView.h"

// Controllers

// Models

// Views

// Vendors

// Categories

// Others

@interface DCYouLikeHeadView ()

@end

@implementation DCYouLikeHeadView

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
    _likeButton = [DCLIRLButton buttonWithType:UIButtonTypeCustom];
    _likeButton.titleLabel.font = PFR13Font;
    [self addSubview:_likeButton];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_likeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - Setter Getter Methods


@end
