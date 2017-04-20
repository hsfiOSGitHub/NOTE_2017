//
//  TVPlayerTitleView.m
//  AVPlayerDemo
//
//  Created by tanyang on 15/11/17.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import "TYVideoTitleView.h"

@interface TYVideoTitleView ()
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UILabel *titleLabel;
@end

#define kViewHorizenlSpacing 10
#define kBackBtnHeightWidth 28

@implementation TYVideoTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addBackButton];
        
        [self addTitleLabel];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self addBackButton];
        
        [self addTitleLabel];
    }
    return self;
}

- (void)addBackButton
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"TYVideoPlayer.bundle/player_back"] forState:UIControlStateNormal];
    [self addSubview:backBtn];
    _backBtn = backBtn;
}

- (void)addTitleLabel
{
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment  = NSTextAlignmentCenter;
    [self addSubview:label];
    _titleLabel = label;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _backBtn.frame = CGRectMake(kViewHorizenlSpacing, 0, kBackBtnHeightWidth+5, kBackBtnHeightWidth);
    
    _titleLabel.frame = CGRectMake(CGRectGetMaxX(_backBtn.frame)+kViewHorizenlSpacing, 0, CGRectGetWidth(self.frame) - 2*(CGRectGetMaxX(_backBtn.frame)+kViewHorizenlSpacing), kBackBtnHeightWidth);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
