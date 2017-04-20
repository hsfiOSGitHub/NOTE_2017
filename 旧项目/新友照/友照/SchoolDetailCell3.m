//
//  SchoolDetailCell3.m
//  友照
//
//  Created by monkey2016 on 16/11/24.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "SchoolDetailCell3.h"

#import "UIButton+HSFButton.h"

@implementation SchoolDetailCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.mapBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];//image在上 label在下
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
