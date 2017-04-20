//
//  TVPlayerBottomView.h
//  AVPlayerDemo
//
//  Created by tanyang on 15/11/18.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYVideoBottomView : UIView

// 当前播放时长
@property (nonatomic, weak, readonly) UILabel *curTimeLabel;
// 总播放时长
@property (nonatomic, weak, readonly) UILabel *totalTimeLabel;
// 全屏按钮
@property (nonatomic, weak, readonly) UIButton *fullScreenBtn;
// 时间进度条
@property (nonatomic, weak, readonly) UISlider *progressSlider;
// 缓冲进度条
@property (nonatomic, weak, readonly) UIProgressView *progressView;


@end
