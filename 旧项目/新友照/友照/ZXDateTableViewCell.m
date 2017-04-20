//
//  ZXDateTableViewCell.m
//  ZXJiaXiao
//
//  Created by Finsen on 16/5/12.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXDateTableViewCell.h"

@implementation ZXDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.keyuyeu.layer.cornerRadius = 7.5;
    self.keyuyeu.layer.masksToBounds = YES;
    self.keyuyeu.backgroundColor = [UIColor colorWithRed:47/255.0 green:194/255.0 blue: 122/255.0 alpha:1];
    
    self.bukeyuyue.layer.cornerRadius = 7.5;
    self.bukeyuyue.layer.masksToBounds = YES;
    self.bukeyuyue.backgroundColor = [UIColor colorWithRed:243/255.0 green:85/255.0 blue: 117/255.0 alpha:1];
}
- (void)setUpCellWith:(NSDictionary *)model{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
