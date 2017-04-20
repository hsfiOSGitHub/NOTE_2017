//
//  DrawerHeader.m
//  CalendarDemo
//
//  Created by monkey2016 on 16/12/21.
//  Copyright © 2016年 monkey2016. All rights reserved.
//

#import "DrawerHeader.h"

@implementation DrawerHeader

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 30;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
