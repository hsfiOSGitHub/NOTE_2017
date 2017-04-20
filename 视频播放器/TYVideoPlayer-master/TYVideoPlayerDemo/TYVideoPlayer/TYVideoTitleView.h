//
//  TVPlayerTitleView.h
//  AVPlayerDemo
//
//  Created by tanyang on 15/11/17.
//  Copyright © 2015年 tanyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TYVideoTitleView : UIView

// 返回 按钮
@property (nonatomic, weak,readonly) UIButton *backBtn;

// 标题
@property (nonatomic, weak,readonly) UILabel *titleLabel;

@end
