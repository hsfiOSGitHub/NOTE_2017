//
//  TVPlayerBottomView.m
//  AVPlayerDemo
//
//  Created by tanyang on 15/11/18.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "TYVideoBottomView.h"

@interface TYVideoBottomView ()
@property (nonatomic, weak) UILabel *curTimeLabel;
@property (nonatomic, weak) UILabel *totalTimeLabel;
@property (nonatomic, weak) UIButton *fullScreenBtn;
@property (nonatomic, weak) UISlider *progressSlider;
@property (nonatomic, weak) UIProgressView *progressView;
@end

#define kButtonHeight 26
#define kButtonWidth 28
#define kTimeLabelWidth 46
#define kViewHorizenlSpace 10

@implementation TYVideoBottomView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addCurrentTimeLabel];
        
        [self addTotalTimeLabel];
        
        [self addFullScreenBtn];
        
        [self addProgressView];
        
        [self addProgressSlider];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self addCurrentTimeLabel];
        
        [self addTotalTimeLabel];
        
        [self addFullScreenBtn];
        
        [self addProgressView];
        
        [self addProgressSlider];
    }
    return self;
}

- (void)addCurrentTimeLabel
{
    UILabel *curTimeLabel = [[UILabel alloc]init];
    curTimeLabel.textColor = [UIColor whiteColor];
    curTimeLabel.font = [UIFont systemFontOfSize:11];
    curTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:curTimeLabel];
    _curTimeLabel = curTimeLabel;
}

- (void)addTotalTimeLabel
{
    UILabel *totalTimeLabel = [[UILabel alloc]init];
    totalTimeLabel.textColor = [UIColor whiteColor];
    totalTimeLabel.font = [UIFont systemFontOfSize:11];
    totalTimeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:totalTimeLabel];
    _totalTimeLabel = totalTimeLabel;
}

- (void)addFullScreenBtn
{
    UIButton *fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fullScreenBtn setImage:[UIImage imageNamed:@"TYVideoPlayer.bundle/player_fullsize"] forState:UIControlStateNormal];
    [self addSubview:fullScreenBtn];
    _fullScreenBtn = fullScreenBtn;
}

- (void)addProgressSlider
{
    UISlider *progressSlider = [[UISlider alloc]init];
    progressSlider.minimumTrackTintColor = [UIColor colorWithRed:252/225. green:110/255. blue:102/255. alpha:0.9];
    progressSlider.maximumTrackTintColor = [UIColor clearColor];
    [progressSlider setThumbImage:[UIImage imageNamed:@"TYVideoPlayer.bundle/player_point"] forState:UIControlStateNormal];
    [self addSubview:progressSlider];
    _progressSlider = progressSlider;
}

- (void)addProgressView
{
    UIProgressView *progressView = [[UIProgressView alloc]init];
    progressView.progressTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.72];
    progressView.trackTintColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.5];
    [self addSubview:progressView];
    _progressView = progressView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _curTimeLabel.frame = CGRectMake(0, 0, kTimeLabelWidth, kButtonHeight);
    
    _fullScreenBtn.frame = CGRectMake(CGRectGetWidth(self.frame) - kButtonWidth - kViewHorizenlSpace, 0, kButtonWidth, kButtonHeight);
    
    _totalTimeLabel.frame = CGRectMake(CGRectGetMinX(_fullScreenBtn.frame) - kTimeLabelWidth, 0, kTimeLabelWidth, kButtonHeight);
    
    _progressSlider.frame = CGRectMake(CGRectGetMaxX(_curTimeLabel.frame), 0, CGRectGetMinX(_totalTimeLabel.frame) - CGRectGetMaxX(_curTimeLabel.frame), kButtonHeight);
    
    _progressView.frame = CGRectMake(0, 0, CGRectGetWidth(_progressSlider.frame)-4, CGRectGetHeight(_progressSlider.frame));
    _progressView.center = _progressSlider.center;
}

@end
