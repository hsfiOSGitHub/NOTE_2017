//
//  KnCellType2_2Cell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/8/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "KnCellType1_2Cell.h"

@interface KnCellType1_2Cell ()

@end

@implementation KnCellType1_2Cell



-(void)setIconAndTitleDic:(NSDictionary *)iconAndTitleDic{
    _iconAndTitleDic = iconAndTitleDic;
    //确定图片和标题
    _icon.image = [UIImage imageNamed:iconAndTitleDic[@"icon"]];
    _title.text = iconAndTitleDic[@"title"];
}

#pragma mark -awakeFromNib
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
