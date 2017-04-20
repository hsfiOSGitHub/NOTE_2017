//
//  CalecdarCell.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/22.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "CalecdarCell.h"

@implementation CalecdarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //配置subViews
    self.spot.layer.masksToBounds = YES;
    self.spot.layer.cornerRadius = 1.5;
    
    self.todayCircle.layer.masksToBounds = YES;
    self.todayCircle.layer.cornerRadius = (KScreenWidth/7 * 6/7 - 10)/2;
//    self.bgView.layer.borderColor = 
}

@end
