//
//  ZXCoachNameStarImageCell.m
//  ZXJiaXiao
//
//  Created by Finsen on 16/4/7.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXCoachNameStarImageCell.h"

@implementation ZXCoachNameStarImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setCellWith:(NSDictionary *)model
{
    if (model) {
        
        _CoachName.text =model[@"name"];
        _schoolName.text = model[@"school_name"];
        if ([model[@"car_code"] isEqualToString:@""]) {
            _CarNumber.hidden = YES;
        }else {
            _CarNumber.hidden = NO;
            _CarNumber.text = model[@"car_code"];

        }
        if ([model[@"tech_age"] isEqualToString:@""])
        {
            _lable2.text = @"--";
        }
        else
        {
            _lable2.text = model[@"tech_age"];
        }
        _lable1.text = [NSString stringWithFormat:@"%.f",[model[@"avg_rate"] floatValue]*100];
        _lable3.text = [NSString stringWithFormat:@"%@",model[@"total_student"]];
        _lable4.text = [NSString stringWithFormat:@"%@",model[@"studying_num"]];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
