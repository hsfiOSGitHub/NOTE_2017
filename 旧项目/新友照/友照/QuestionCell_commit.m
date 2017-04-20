//
//  QuestionCell_commit.m
//  友照
//
//  Created by monkey2016 on 16/12/9.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "QuestionCell_commit.h"

@implementation QuestionCell_commit

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.commitBtn.layer.masksToBounds = YES;
    self.commitBtn.layer.cornerRadius = 10;
    self.commitBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.commitBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
