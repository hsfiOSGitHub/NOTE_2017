//
//  ZXKongKaQuanView.m
//  ZXJiaXiao
//
//  Created by yujian on 16/7/1.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXKongKaQuanView.h"

@implementation ZXKongKaQuanView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self shouwUI];
    }
    return self;
}

- (void)shouwUI {
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor whiteColor];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 100)/2, (self.frame.size.height - 100)/2, 100, 100)];
    imageView.image = [UIImage imageNamed:@"卡通"];
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - 100)/2 + 105 , self.frame.size.width, 30)];
    _label.text = @"您还没有卡券哦";
    _label.textColor = [UIColor darkGrayColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = [UIFont systemFontOfSize:14];
    
    //将图片视图和描述的label添加到父视图上
    [self addSubview:imageView];
    [self addSubview:_label];
}

- (void)show {
    
}
- (void)dismiss {
    [self removeFromSuperview];
}



@end
