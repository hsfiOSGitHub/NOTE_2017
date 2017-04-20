//
//  OrderPatientTableViewCell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/31.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "OrderPatientTableViewCell.h"

@implementation OrderPatientTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numLable.layer.masksToBounds = YES;
    self.numLable.layer.cornerRadius = 12.5;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
