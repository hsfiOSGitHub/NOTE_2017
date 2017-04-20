//
//  ChartCountCell.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/6.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartCountCell : UITableViewCell<StarRatingViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *dateIcon;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishedLabel;
@property (weak, nonatomic) IBOutlet UILabel *unfinishedLabel;
@property (weak, nonatomic) IBOutlet UIView *starView;

@property (nonatomic,assign) CGFloat percent;

@end
