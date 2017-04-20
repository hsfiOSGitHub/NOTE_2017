//
//  ChartLineCell.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/9.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ChartLineCell.h"

@interface ChartLineCell ()<SCChartDataSource>

@property (nonatomic,strong) SCChart *chartView;


@end

@implementation ChartLineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}



//>>>>>>>>>>>>>>>>>>>SCChart<<<<<<<<<<<<<<<<<<<<<<

-(void)setDraw:(NSString *)draw{
    _draw = draw;
    //创建折线图
    if (_chartView) {
        [_chartView removeFromSuperview];
        _chartView = nil;
    }
    _chartView = [[SCChart alloc] initwithSCChartDataFrame:CGRectMake(10, (self.frame.size.height-150)/2, [UIScreen mainScreen].bounds.size.width - 20, 150)
                                                withSource:self
                                                 withStyle:SCChartLineStyle];
    [_chartView showInView:self.contentView];
}

#pragma mark - @required
//横坐标标题数组
- (NSArray *)SCChart_xLableArray:(SCChart *)chart {
    return self.XTitlesArr;
}
//数值多重数组
- (NSArray *)SCChart_yValueArray:(SCChart *)chart {
    return @[self.finishedArr,self.unfinishedArr];
}

#pragma mark - @optional
//颜色数组
- (NSArray *)SCChart_ColorArray:(SCChart *)chart {
    return @[SCGreen,SCRed];
}

#pragma mark 折线图专享功能
//标记数值区域
- (CGRange)SCChartMarkRangeInLineChart:(SCChart *)chart {
    return CGRangeZero;
}

//判断显示横线条
- (BOOL)SCChart:(SCChart *)chart ShowHorizonLineAtIndex:(NSInteger)index {
    return YES;
}

//判断显示最大最小值
- (BOOL)SCChart:(SCChart *)chart ShowMaxMinAtIndex:(NSInteger)index {
    return YES;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
