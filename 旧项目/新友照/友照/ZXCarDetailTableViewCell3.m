//
//  ZXCarDetailTableViewCell3.m
//  ZXJiaXiao
//
//  Created by Finsen on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXCarDetailTableViewCell3.h"

@implementation ZXCarDetailTableViewCell3

- (void)awakeFromNib {
    [super awakeFromNib];
   
}
- (void)setUpCellWith:(NSArray *)model
{
    if ([model[0][@"list"] isKindOfClass:[NSArray class]])
    {
        _label.text = @"";
    }
    else
    {
        _label.text = @"剩余0张，当前排队人数10人。";
    }
   
    [_label setAdjustsFontSizeToFitWidth:YES];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
}

@end
