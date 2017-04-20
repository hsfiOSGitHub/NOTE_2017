//
//  ZXTableViewCell.m
//  ZXJiaXiao
//
//  Created by ZX on 16/3/16.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXTableViewCell.h"
@implementation ZXTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/*
 //学习记录
 dataTypeStudyRecord = 0,
 //预约记录
 dataTypeYuYueRecord,
 //取消预约
 dataTypeCancel
 */
- (void)setCellWith:(NSDictionary *)model andDataType:(NSString*)dataType
{
    if (model == nil)
    {
        return;
    }
    _JiaoLianLabel.text = [NSString stringWithFormat:@"教练:%@",model[@"teacher_name"]];
    NSArray *startTimes = [model[@"start_time"] componentsSeparatedByString:@" "];
    NSArray *endTimes = [model[@"end_time"] componentsSeparatedByString:@" "];
    //做一个判断，学习记录显示class_time，预约记录和取消预约显示start_time
    if([dataType isEqualToString:@"study"])
    {
        _classTimeLabel.hidden=NO;
        _classTimeLabel.text = [NSString stringWithFormat:@"时间:%@",model[@"class_time"]];
    }
    else if([dataType isEqualToString:@"book"])
    {
        _classTimeLabel.hidden=NO;
        _classTimeLabel.text = [NSString stringWithFormat:@"时间:%@ %@~%@",startTimes[0],[startTimes[1] substringWithRange:NSMakeRange(0,5)],[endTimes[1] substringWithRange:NSMakeRange(0, 5)]];
    }
    else if([dataType isEqualToString:@"cancel"])
    {
        _classTimeLabel.hidden=YES;
    }
}

- (void)setUpButtonState:(NSDictionary *)model
{
    //status=2 代表可以去评论，status=5,代表已经评论过
    if ([model[@"status"] isEqualToString:@"2"])
    {
        [_buttonInfo setTitle:@"去评分" forState:UIControlStateNormal];
        _buttonInfo.userInteractionEnabled = YES;
        _buttonInfo.backgroundColor = [UIColor colorWithRed:108/255.0 green:169/255.0 blue:255/255.0 alpha:1];
        [_buttonInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [_buttonInfo setTitle:@"已评分" forState:UIControlStateNormal];
        _buttonInfo.userInteractionEnabled = NO;
        _buttonInfo.backgroundColor = [UIColor colorWithRed:255/255.0 green:112/255.0 blue:68/255.0 alpha:1];
        [_buttonInfo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

@end
