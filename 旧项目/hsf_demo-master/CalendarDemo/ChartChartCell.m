//
//  ChartChartCell.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/6.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ChartChartCell.h"

@interface ChartChartCell ()<SCChartDelegate>
@property (nonatomic,strong) SCPieChart *chartView;
@end

@implementation ChartChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

-(void)setDraw:(NSString *)draw{
    _draw = draw;
    //创建饼图
    if (_chartView) {
        [_chartView removeFromSuperview];
        _chartView = nil;
    }
    NSArray *items = @[[SCPieChartDataItem dataItemWithValue:self.finishedValue color:SCRed description:@"已完成"],[SCPieChartDataItem dataItemWithValue:self.unfinishedValue color:SCBlue description:@"未完成"]];
    
    _chartView = [[SCPieChart alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-180)/2, 10, 180.0, 180.0) items:items];
    _chartView.delegate = self;
    _chartView.descriptionTextColor = [UIColor whiteColor];
    _chartView.descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:12.0];
    [_chartView strokeChart];
    [self.bgView addSubview:_chartView];
}
#pragma mark - @optional
//颜色数组
- (NSArray *)SCChart_ColorArray:(SCChart *)chart {
    return @[SCGreen,SCRed];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
