//
//  amAndPmTableViewCell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/31.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "amAndPmTableViewCell.h"

@implementation amAndPmTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.amBtn.layer.borderWidth = 1.0;
    self.amBtn.layer.borderColor = KRGB(0, 172, 204, 1.0).CGColor;
    self.amBtn.layer.masksToBounds = YES;
    self.amBtn.layer.cornerRadius = 8;
    
    self.pmBtn.layer.borderWidth = 1.0;
    self.pmBtn.layer.borderColor = KRGB(0, 172, 204, 1.0).CGColor;
    self.pmBtn.layer.masksToBounds = YES;
    self.pmBtn.layer.cornerRadius = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
