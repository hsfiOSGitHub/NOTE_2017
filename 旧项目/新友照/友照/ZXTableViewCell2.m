//
//  ZXTableViewCell2.m
//  ZXJiaXiao
//
//  Created by yujian on 16/5/21.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXTableViewCell2.h"

@implementation ZXTableViewCell2

- (void)awakeFromNib
{
    [super awakeFromNib];
    _quanMaLabel.text = @"券码";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
