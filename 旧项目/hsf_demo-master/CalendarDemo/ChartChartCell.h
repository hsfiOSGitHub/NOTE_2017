//
//  ChartChartCell.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/6.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartChartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic,assign) CGFloat finishedValue;
@property (nonatomic,assign) CGFloat unfinishedValue;

@property (nonatomic,strong) NSString *draw;

@end
