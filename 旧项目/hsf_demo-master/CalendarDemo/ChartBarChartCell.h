//
//  ChartBarChartCell.h
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/6.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartBarChartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic,strong) NSArray *XTitlesArr;
@property (nonatomic,strong) NSArray *finishedArr;
@property (nonatomic,strong) NSArray *unfinishedArr;

@property (nonatomic,strong) NSString *draw;

@end
