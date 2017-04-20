//
//  TableViewCell_xiao_xi.m
//  huan_xin
//
//  Created by ZX on 16/9/7.
//  Copyright © 2016年 ZX_XPH. All rights reserved.
//

#import "TableViewCell_xiao_xi.h"

@implementation TableViewCell_xiao_xi

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tou_xiang.layer.cornerRadius = 30;
    self.tou_xiang.layer.masksToBounds = YES;
    
    self.wei_du_xiao_xi.layer.cornerRadius = 10;
    self.wei_du_xiao_xi.layer.masksToBounds = YES;

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
