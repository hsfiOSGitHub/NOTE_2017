//
//  ZX_YouHuiQuanTableViewCell.m
//  友照
//
//  Created by cleloyang on 2017/1/10.
//  Copyright © 2017年 ZX_XPH. All rights reserved.
//

#import "ZX_YouHuiQuanTableViewCell.h"

@implementation ZX_YouHuiQuanTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _youHuiQuanBtn.layer.cornerRadius = 10;
    _youHuiQuanBtn.layer.masksToBounds = YES;
    _youHuiQuanBtn.layer.borderWidth = 1;
    _youHuiQuanBtn.layer.borderColor = [ZX_BG_COLOR CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
