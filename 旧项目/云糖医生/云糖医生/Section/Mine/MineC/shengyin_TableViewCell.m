//
//  shengyin_TableViewCell.m
//  云糖医
//
//  Created by ZX on 16/11/30.
//  Copyright © 2016年 yuntangyi. All rights reserved.
//

#import "shengyin_TableViewCell.h"

@implementation shengyin_TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([ZXUD boolForKey:@"sy"])
    {
        _sen.on=YES;
    }
    else
    {
        _sen.on=NO;
    }
}
- (IBAction)shengyin:(UISwitch *)sender {
    
    if (sender.on)
    {
        [ZXUD setBool:YES forKey:@"sy"];
    }
    else
    {
         [ZXUD setBool:NO forKey:@"sy"];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
