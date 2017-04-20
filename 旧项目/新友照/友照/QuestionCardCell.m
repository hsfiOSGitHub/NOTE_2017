//
//  QuestionCardCell.m
//  友照
//
//  Created by monkey2016 on 16/12/8.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "QuestionCardCell.h"

@implementation QuestionCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    //设置边框圆角
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 10;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1;
}

@end
