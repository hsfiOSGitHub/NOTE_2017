//
//  QuestionCell_question.m
//  友照
//
//  Created by monkey2016 on 16/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "QuestionCell_question.h"



@implementation QuestionCell_question

- (void)awakeFromNib {
    [super awakeFromNib];
    //调用此方法后，才可以获取到正确的frame
    [self layoutIfNeeded];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
