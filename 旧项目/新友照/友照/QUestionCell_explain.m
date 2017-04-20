//
//  QUestionCell_explain.m
//  友照
//
//  Created by monkey2016 on 16/12/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "QUestionCell_explain.h"

@implementation QUestionCell_explain

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bgView.layer.masksToBounds = YES;
    self.bgView.layer.cornerRadius = 10;
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
