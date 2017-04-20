//
//  ImageVTableViewCell.m
//  友照
//
//  Created by chaoyang on 16/12/5.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "ImageVTableViewCell.h"

@implementation ImageVTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.imageV.layer.cornerRadius = 45;
    self.imageV.layer.masksToBounds = YES;
    self.imageV.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
    self.imageV.layer.borderWidth = 1.0;
    self.SetBtn.layer.borderWidth = 1.0;
    self.SetBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.SetBtn.layer.cornerRadius = 5;
    self.SetBtn.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
