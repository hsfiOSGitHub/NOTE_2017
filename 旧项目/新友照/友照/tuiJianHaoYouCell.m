//
//  tuiJianHaoYouCell.m
//  ZXJiaXiao
//
//  Created by yujian on 16/6/24.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "tuiJianHaoYouCell.h"

@implementation tuiJianHaoYouCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _headerImage.layer.cornerRadius = 25;
    _headerImage.layer.masksToBounds = YES;
    _headerImage.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    _headerImage.layer.borderWidth = 1;
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end
