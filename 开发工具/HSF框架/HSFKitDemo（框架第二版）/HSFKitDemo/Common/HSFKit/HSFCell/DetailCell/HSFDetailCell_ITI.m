//
//  HSFDetailCell_ITI.m
//  HSFBase
//
//  Created by JuZhenBaoiMac on 2017/6/26.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "HSFDetailCell_ITI.h"

@implementation HSFDetailCell_ITI

- (void)awakeFromNib {
    [super awakeFromNib];
    //img圆角
    self.img.layer.masksToBounds = YES;
    self.img.layer.cornerRadius = 30;
    self.img.layer.borderColor = [UIColor whiteColor].CGColor;
    self.img.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
