//
//  TYVideoErrorView.m
//  TYVideoPlayerDemo
//
//  Created by tany on 16/7/12.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYVideoErrorView.h"

@interface TYVideoErrorView ()
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic,weak) UILabel *titleLabel;
@property (nonatomic,weak) UIButton *msgBtn;
@end

#define kViewHorizenlSpacing 10
#define kBackBtnHeightWidth 28
#define kTitleLabelHeight 18
#define kMsgBtnWidthHeight 60

@implementation TYVideoErrorView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addBackButton];
        
        [self addTitleLabel];
        
        [self addMsgButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self addBackButton];
        
        [self addTitleLabel];
        
        [self addMsgButton];
    }
    return self;
}

- (void)addBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"TYVideoPlayer.bundle/player_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backBtn];
    _backBtn = backBtn;
}

- (void)addTitleLabel
{
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    _titleLabel = titleLabel;
}

- (void)addMsgButton
{
    UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [msgBtn setBackgroundImage:[UIImage imageNamed:@"TYVideoPlayer.bundle/player_replay"] forState:UIControlStateNormal];
    [msgBtn addTarget:self action:@selector(videoReplayAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:msgBtn];
    _msgBtn = msgBtn;
}

#pragma mark  - setter

- (void)setTitle:(NSString *)title
{
    _titleLabel.text = title;
}

#pragma mark - action

- (void)videoReplayAction:(UIButton *)button
{
    if (_eventActionHandle) {
        _eventActionHandle(TYVideoErrorEventReplay);
    }
}

- (void)backAction:(UIButton *)button
{
    if (_eventActionHandle) {
        _eventActionHandle(TYVideoErrorEventBack);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _backBtn.frame = CGRectMake(kViewHorizenlSpacing, 20, kBackBtnHeightWidth, kBackBtnHeightWidth);
    _msgBtn.frame = CGRectMake(0, 0, kMsgBtnWidthHeight, kMsgBtnWidthHeight);
    _msgBtn.center = self.center;
    _titleLabel.frame = CGRectMake(0, CGRectGetMaxY(_msgBtn.frame)+6, CGRectGetWidth(self.frame), kTitleLabelHeight);
    
}

@end
