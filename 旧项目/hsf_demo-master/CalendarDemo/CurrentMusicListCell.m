//
//  CurrentMusicListCell.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/22.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "CurrentMusicListCell.h"

@implementation CurrentMusicListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.singerPic.layer.masksToBounds = YES;
    self.singerPic.layer.cornerRadius = 20;
    self.singerPic.layer.borderColor = [KRGB(23, 159, 155, 1.0) CGColor];
    self.singerPic.layer.borderWidth = 1;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
