//
//  ZX_WoDe_TableViewCell1.m
//  友照
//
//  Created by cleloyang on 2016/11/30.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ZX_WoDe_TableViewCell1.h"

@implementation ZX_WoDe_TableViewCell1

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _yongHuTouXiangImg.layer.cornerRadius = 45;
    _yongHuTouXiangImg.layer.masksToBounds = YES;
    _yongHuTouXiangImg.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    _yongHuTouXiangImg.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
