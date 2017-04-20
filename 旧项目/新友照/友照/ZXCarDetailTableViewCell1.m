//
//  ZXCarDetailTableViewCell1.m
//  ZXJiaXiao
//
//  Created by Finsen on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXCarDetailTableViewCell1.h"

@implementation ZXCarDetailTableViewCell1

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setUpCellWith:(NSArray *)model {
   
    if([model[0][@"list"] isKindOfClass:[NSArray class]])
    {
        _oldPriceLabel.text = [NSString stringWithFormat:@"原价￥%@/圈",model[0][@"list"][0][@"old_price"]];
        _PriceLabel.text = [NSString stringWithFormat:@"￥%@/圈",model[0][@"list"][0][@"price"]];
        
    }
    else
    {
        _oldPriceLabel.text = @"原价￥25/圈";
        _PriceLabel.text = @"￥25/圈";
    }
}

@end
