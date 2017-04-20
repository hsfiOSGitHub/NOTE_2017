//
//  TalkBtn.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/5.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "TalkBtn.h"

@implementation TalkBtn
//初始化方法
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // 配置btn
        UIImage *img = [UIImage imageNamed:@"talkPic"];
        UIImage *newImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 16, 16) resizingMode:UIImageResizingModeStretch];
        [self setBackgroundImage:newImg forState:UIControlStateNormal];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // 配置btn
    UIImage *img = [UIImage imageNamed:@"talkPic"];
    UIImage *newImg = [img resizableImageWithCapInsets:UIEdgeInsetsMake(15, 15, 15, 15) resizingMode:UIImageResizingModeStretch];
    [self setBackgroundImage:newImg forState:UIControlStateNormal];
    
    [self setTitleColor:KRGB(0, 172, 204, 1) forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:10];
    
}


@end
