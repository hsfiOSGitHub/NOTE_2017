//
//  zhen_dong_TableViewCell.m
//  云糖医
//
//  Created by ZX on 16/11/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "zhen_dong_TableViewCell.h"

@implementation zhen_dong_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([ZXUD boolForKey:@"zd"])
    {
        _sent.on=YES;
    }
    else
    {
        _sent.on=NO;
    }
}

- (IBAction)zhendong:(UISwitch *)sender {
    if (sender.on)
    {
        [ZXUD setBool:YES forKey:@"zd"];
    }
    else
    {
         [ZXUD setBool:NO forKey:@"zd"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
