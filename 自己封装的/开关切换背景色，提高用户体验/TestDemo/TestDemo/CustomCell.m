//
//  CustomCell.m
//  TestDemo
//
//  Created by JuZhenBaoiMac on 2017/4/28.
//  Copyright © 2017年 JuZhenBaoiMac. All rights reserved.
//

#import "CustomCell.h"



@implementation CustomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.layer.masksToBounds = YES;
    
    self.mySwitch.layer.masksToBounds = YES;
    self.mySwitch.layer.borderColor = [UIColor whiteColor].CGColor;
    self.mySwitch.layer.borderWidth = 1;
    self.mySwitch.layer.cornerRadius = 31/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
