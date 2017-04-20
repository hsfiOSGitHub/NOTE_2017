//
//  SchoolDetailCell1.m
//  友照
//
//  Created by monkey2016 on 16/11/24.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SchoolDetailCell1.h"

#import "UIButton+HSFButton.h"

@implementation SchoolDetailCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    self.picBtn.layer.masksToBounds = YES;
    self.picBtn.layer.cornerRadius = 25;
    [self.picBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];//image在上 label在下
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
