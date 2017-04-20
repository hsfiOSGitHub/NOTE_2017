//
//  ToolCell.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/16.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ToolCell.h"

@implementation ToolCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //
    self.icon.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius  = 13;
    
}

@end
