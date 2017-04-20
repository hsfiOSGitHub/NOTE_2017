//
//  LocalMusicCell2.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/20.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "LocalMusicCell2.h"

@implementation LocalMusicCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.myLikeBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.myCollectionBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.myMusicListBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.downloadCenterBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.recentBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.musicLibBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.redioBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.mvBtn layoutButtonWithEdgeInsetsStyle:HSFButtonEdgeInsetsStyleTop imageTitleSpace:5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
