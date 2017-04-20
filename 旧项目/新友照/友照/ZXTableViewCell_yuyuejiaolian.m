//
//  ZXTableViewCell_yuyuejiaolian.m
//  ZXJiaXiao
//
//  Created by ZX on 16/8/1.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXTableViewCell_yuyuejiaolian.h"

@implementation ZXTableViewCell_yuyuejiaolian

- (void)awakeFromNib
{
    [super awakeFromNib];
    _touxiang.layer.cornerRadius = 36;
    _touxiang.layer.masksToBounds = YES;
    _touxiang.layer.borderWidth = 1;
    _touxiang.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
