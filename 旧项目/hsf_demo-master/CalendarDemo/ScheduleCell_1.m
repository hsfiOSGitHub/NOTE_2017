//
//  ScheduleCell_1.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/23.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "ScheduleCell_1.h"

@implementation ScheduleCell_1

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.pic1.layer.masksToBounds = YES;
    self.pic2.layer.masksToBounds = YES;
    self.pic3.layer.masksToBounds = YES;
    
    self.pic1.layer.cornerRadius = 10;
    self.pic2.layer.cornerRadius = 10;
    self.pic3.layer.cornerRadius = 10;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
