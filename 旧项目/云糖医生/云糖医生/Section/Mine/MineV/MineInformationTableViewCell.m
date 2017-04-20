//
//  MineInformationTableViewCell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "MineInformationTableViewCell.h"

@implementation MineInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageV.layer.masksToBounds = YES;
    self.headImageV.layer.cornerRadius = 40;
//    self.keShiAndPositionLable.adjustsFontSizeToFitWidth = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
