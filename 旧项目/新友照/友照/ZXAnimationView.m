
//
//  ZXAnimationView.m
//  animationView
//
//  Created by ZX on 16/4/12.
//  Copyright © 2016年 ZXNavigatio. All rights reserved.
//

#import "ZXAnimationView.h"
@interface ZXAnimationView()

@end
@implementation ZXAnimationView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 3,self.frame.size.height/2 - self.frame.size.width  / 6, self.frame.size.width /3,  self.frame.size.width /3)];
        self.userInteractionEnabled = NO;
        self.backgroundColor = [UIColor whiteColor];
        NSMutableArray *imageArr = [NSMutableArray array];
        for (int index = 1; index < 5; index++)
        {
            NSString *imageName = [NSString stringWithFormat:@"car%d.png",index];
            UIImage *image = [UIImage imageNamed:imageName];
            [imageArr addObject:image];
        }
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_imageView.frame), KScreenWidth, 30)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14];
        _label.text = @"正在努力加载...";
        [self addSubview:_label];
        _imageView.animationImages = imageArr;
        [_imageView setAnimationRepeatCount:0];
        [_imageView setAnimationDuration:1];
        [_imageView startAnimating];
        [self addSubview:_imageView];
        
    }
    return self;
}

- (void)show
{
    
}
- (void)dismiss
{
    [self removeFromSuperview];
}
//独立动画视图
+ (UIImageView *)createAnimationView
{
   UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,  KScreenWidth/4,  KScreenWidth/4)];
    NSMutableArray *imageArr = [NSMutableArray array];
    for (int index = 1; index < 5; index++)
    {
        NSString *imageName = [NSString stringWithFormat:@"car%d.png",index];
        UIImage *image = [UIImage imageNamed:imageName];
        [imageArr addObject:image];
    }
    imageView.animationImages = imageArr;
    [imageView setAnimationRepeatCount:0];
    [imageView setAnimationDuration:1];
    [imageView startAnimating];
    return imageView;
}



@end
