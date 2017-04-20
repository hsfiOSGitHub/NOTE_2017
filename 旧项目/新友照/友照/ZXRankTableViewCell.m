//
//  ZXRankTableViewCell.m
//  ZXJiaXiao
//
//  Created by ZX on 16/3/28.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXRankTableViewCell.h"
@implementation ZXRankTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _headImage.layer.cornerRadius = 30;
    _headImage.layer.masksToBounds = YES;
    _headImage.layer.borderWidth = 1;
    _headImage.layer.borderColor = [KRGB(109, 156, 183, 1) CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setCellWith:(NSDictionary *)model
{
    //判断男女
    if ([model[@"gender"] integerValue]==0)
    {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model[@"pic"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    }
    else if([model[@"gender"] integerValue]==1)
    {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:model[@"pic"]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    }
    self.nameLabel.text = model[@"name"];
    self.scoreLabel.text = [NSString stringWithFormat:@"%@分",model[@"score"]];
    self.timeLabel.text = [NSString stringWithFormat:@"用时:%02d:%02d",[model[@"use_time"] intValue]/60,[model[@"use_time"] intValue] % 60];
}

@end
