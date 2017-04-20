//
//  SystemNewsCell.m
//  yuntangyi
//
//  Created by yuntangyi on 16/9/14.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "SystemNewsCell.h"

@interface SystemNewsCell ()
@property (weak, nonatomic) IBOutlet UILabel *medicineName;//药名
@property (weak, nonatomic) IBOutlet UILabel *medicineInfo;//药品介绍
@property (weak, nonatomic) IBOutlet UILabel *time;//时间
@property (weak, nonatomic) IBOutlet UIButton *showDetail;//查看详情

@end

@implementation SystemNewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // 配置subviews
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
