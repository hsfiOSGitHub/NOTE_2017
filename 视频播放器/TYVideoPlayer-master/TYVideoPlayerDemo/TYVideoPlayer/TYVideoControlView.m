//
//  TYPlayerControlView.m
//  TYVideoPlayerDemo
//
//  Created by tany on 16/7/5.
//  Copyright © 2016年 tany. All rights reserved.
//

#import "TYVideoControlView.h"
#import "TYVideoTitleView.h"
#import "TYVideoBottomView.h"

#define kBackBtnHeight 35
#define kBackBtnTopEdage 12
#define kBackBtnLeftEdage 10
#define kTitleViewTopEdge 20
#define kTitleViewHight 28
#define kBottomViewBottomEdge 4
#define kBottomViewHeight 26
#define kSuspendBtnHeight 60

@interface TYVideoControlView ()

@property (nonatomic, weak) UIView *contentView;

@property (nonatomic, weak) TYVideoTitleView *titleView;

@property (nonatomic, weak) TYVideoBottomView *bottomView;

@property (nonatomic, weak) UIButton *suspendBtn;

@end

@implementation TYVideoControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addContentView];
        
        [self addTitleView];
        
        [self addBottomView];
        
        [self addSuspendButton];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self addContentView];
        
        [self addTitleView];
        
        [self addBottomView];
        
        [self addSuspendButton];
    }
    return self;
}

#pragma mark - add subvuew

- (void)addContentView
{
    UIView *contentView = [[UIView alloc]init];
    [self addSubview:contentView];
    _contentView = contentView;
}

- (void)addTitleView
{
    TYVideoTitleView *titleView = [[TYVideoTitleView alloc]init];
    [titleView.backBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:titleView];
    _titleView = titleView;
}

- (void)addBottomView
{
    TYVideoBottomView *bottomView = [[TYVideoBottomView alloc]init];
    bottomView.curTimeLabel.text = @"00:00";
    bottomView.totalTimeLabel.text = @"00:00";
    [bottomView.fullScreenBtn addTarget:self action:@selector(fullScreenAction:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView.progressSlider addTarget:self action:@selector(sliderBeginDraging:) forControlEvents:UIControlEventTouchDown];
    [bottomView.progressSlider addTarget:self action:@selector(sliderIsDraging:) forControlEvents:UIControlEventValueChanged];
    [bottomView.progressSlider addTarget:self action:@selector(sliderEndDraging:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
    [_contentView addSubview:bottomView];
    _bottomView = bottomView;
}

- (void)addSuspendButton
{
    UIButton *suspendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    suspendBtn.selected = YES;
    suspendBtn.frame = CGRectMake(0, 0, kSuspendBtnHeight, kSuspendBtnHeight);
    suspendBtn.adjustsImageWhenHighlighted = NO;
    [suspendBtn setBackgroundImage:[UIImage imageNamed:@"TYVideoPlayer.bundle/player_pauseBig"] forState:UIControlStateNormal];
    [suspendBtn setBackgroundImage:[UIImage imageNamed:@"TYVideoPlayer.bundle/player_playBig"] forState:UIControlStateSelected];
    [suspendBtn addTarget:self action:@selector(suspendAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:suspendBtn];
    _suspendBtn = suspendBtn;
}

#pragma mark - pravite

- (BOOL)isOrientationPortrait
{
    return [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIDeviceOrientationPortraitUpsideDown;
}

- (void)recieveControlEvent:(TYVideoControlEvent)event
{
    if ([_delegate respondsToSelector:@selector(videoControlView:shouldResponseControlEvent:)]
        && ![_delegate videoControlView:self shouldResponseControlEvent:event]) {
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(videoControlView:recieveControlEvent:)]) {
        [_delegate videoControlView:self recieveControlEvent:event];
    }
}

#pragma mark - public

- (void)setTitle:(NSString *)title
{
    _titleView.titleLabel.text = title;
}

- (void)setCurrentVideoTime:(NSString *)time
{
    _bottomView.curTimeLabel.text = time;
}

- (void)setTotalVideoTime:(NSString *)time
{
    _bottomView.totalTimeLabel.text = time;
}

- (void)setSliderProgress:(CGFloat)progress
{
    _bottomView.progressSlider.value = progress;
}

- (void)setBufferProgress:(CGFloat)progress
{
    [_bottomView.progressView setProgress:progress animated:YES];
}

- (void)setFullScreen:(BOOL)fullScreen
{
    _bottomView.fullScreenBtn.hidden = fullScreen;
}

- (void)setPlayBtnState:(BOOL)isPlayState
{
    _suspendBtn.selected = isPlayState;
}

- (void)setPlayBtnHidden:(BOOL)hidden
{
    _suspendBtn.hidden = hidden;
}

- (BOOL)contentViewHidden
{
    return _contentView.hidden;
}

- (void)setContentViewHidden:(BOOL)hidden
{
    _contentView.hidden = hidden;
}

- (void)setTimeSliderHidden:(BOOL)hidden
{
    _bottomView.curTimeLabel.hidden = hidden;
    _bottomView.totalTimeLabel.hidden = hidden;
    _bottomView.progressSlider.hidden = hidden;
    _bottomView.progressView.hidden = hidden;
}

#pragma mark - action

- (void)sliderBeginDraging:(UISlider *)sender
{
    if ([_delegate respondsToSelector:@selector(videoControlView:state:sliderToProgress:)]) {
        [_delegate videoControlView:self state:TYSliderStateBegin sliderToProgress:sender.value];
    }
}

- (void)sliderIsDraging:(UISlider *)sender
{
    if ([_delegate respondsToSelector:@selector(videoControlView:state:sliderToProgress:)]) {
        [_delegate videoControlView:self state:TYSliderStateDraging sliderToProgress:sender.value];
    }
}

- (void)sliderEndDraging:(UISlider *)sender
{
    if ([_delegate respondsToSelector:@selector(videoControlView:state:sliderToProgress:)]) {
        [_delegate videoControlView:self state:TYSliderStateEnd sliderToProgress:sender.value];
    }
}

- (void)fullScreenAction:(UIButton *)sender
{
    [self recieveControlEvent:[self isOrientationPortrait] ? TYVideoControlEventFullScreen : TYVideoControlEventNormalScreen];
}

- (void)backAction:(UIButton *)sender
{
    [self recieveControlEvent:TYVideoControlEventBack];
}

- (void)suspendAction:(UIButton *)sender
{
    [self recieveControlEvent:sender.isSelected ? TYVideoControlEventPlay:TYVideoControlEventSuspend];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _contentView.frame = self.bounds;
    _titleView.frame = CGRectMake(0, kTitleViewTopEdge, CGRectGetWidth(_contentView.frame), kTitleViewHight);
    _bottomView.frame = CGRectMake(0, CGRectGetHeight(_contentView.frame) - kBottomViewHeight - kBottomViewBottomEdge, CGRectGetWidth(_contentView.frame), kBottomViewHeight);
    _suspendBtn.center = _contentView.center;
}

@end
