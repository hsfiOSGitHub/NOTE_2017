//
//  KongPlaceHolderView.m
//  yuntangyi
//
//  Created by yuntangyi on 16/10/10.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KongPlaceHolderView.h"

@implementation KongPlaceHolderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, frame.size.width/3,  frame.size.width/3)];
        _imageV.center = CGPointMake(frame.size.width / 2, frame.size.height / 2 - 50);
        _imageV.image = [UIImage imageNamed:@"NetDefeat"];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageV.frame), frame.size.width, 30)];
        _label.text = @"您还没有消息哦";
        _label.textColor = [UIColor darkGrayColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14];
        
        //将图片视图和描述的label添加到父视图上
        [self addSubview:_imageV];
        [self addSubview:_label];
    }
    return self;
}
- (void)shouwUI
{
    

}

- (void)dismiss
{
    [self removeFromSuperview];
}


@end
