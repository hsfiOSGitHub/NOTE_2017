//
//  EditScheduleCell_pic.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/27.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "EditScheduleCell_pic.h"

@implementation EditScheduleCell_pic

- (void)awakeFromNib {
    [super awakeFromNib];
    //圆角
    self.pic1.layer.masksToBounds = YES;
    self.pic2.layer.masksToBounds = YES;
    self.pic3.layer.masksToBounds = YES;
    
    self.pic1.layer.cornerRadius = 5;
    self.pic2.layer.cornerRadius = 5;
    self.pic3.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
