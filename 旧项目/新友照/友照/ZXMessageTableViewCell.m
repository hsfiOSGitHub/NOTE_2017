//
//  ZXMessageTableViewCell.m
//  ZXJiaXiao
//
//  Created by Finsen on 16/6/23.
//  Copyright © 2016年 ZX. All rights reserved.
//

#import "ZXMessageTableViewCell.h"

@implementation ZXMessageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setModel:(NSDictionary *)model
{
    _title.text = model[@"title"];
    _date.text = [model[@"time"] substringWithRange:NSMakeRange(5, 5)];
    if ([[model allKeys] containsObject:@"url"])
    {
        _imgV.hidden = NO;
        _content.hidden = YES;
        _content1.text = model[@"content"];
    }
    else
    {
        _imgV.hidden = YES;
        _content1.hidden = YES;
        _content.text = model[@"content"];
    }
}

@end
