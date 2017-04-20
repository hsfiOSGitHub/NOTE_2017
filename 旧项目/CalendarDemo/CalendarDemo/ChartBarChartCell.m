//
//  ChartBarChartCell.m
//  CalendarDemo
//
//  Created by monkey2016 on 17/1/6.
//  Copyright © 2017年 monkey2016. All rights reserved.
//

#import "ChartBarChartCell.h"

@interface ChartBarChartCell ()<SCChartDataSource>
//@property (nonatomic,strong) SCChart *chartView;
@property (nonatomic,strong) JHColumnChart *column;
@end

@implementation ChartBarChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
//>>>>>>>>>>>>>>>>>>JHChart<<<<<<<<<<<<<<<<<<<<<
-(void)setDraw:(NSString *)draw{
    _draw = draw;
    if (_column) {
        [_column removeFromSuperview];
        _column = nil;
    }
    
    _column = [[JHColumnChart alloc] initWithFrame:CGRectMake(0, 10, KScreenWidth - 20, 180)];
    /*        Create an array of data sources, each array is a module data. For example, the first array can represent the average score of a class of different subjects, the next array represents the average score of different subjects in another class        */
//    column.valueArr = @[
//  @[@12,@15,@20],
//  @[@22,@15,@20],
//  @[@12,@5,@40],
//  @[@2,@15,@20],
//  @[@20,@15,@26]
//  ];
    NSMutableArray *valueArr = [NSMutableArray array];
    for (int i = 0; i < self.XTitlesArr.count; i++) {
        NSMutableArray *arr = [NSMutableArray array];
        [arr addObject:self.finishedArr[i]];
        [arr addObject:self.unfinishedArr[i]];
        [valueArr addObject:arr];
    }
    _column.valueArr = valueArr;
    /*       This point represents the distance from the lower left corner of the origin.         */
    _column.originSize = CGPointMake(30, 30);
    /*    The first column of the distance from the starting point     */
    _column.drawFromOriginX = 10;
    _column.typeSpace = 10;
    /*        Column width         */
    _column.columnWidth = 40;
    /*        X, Y axis font color         */
    _column.drawTextColorForX_Y = [UIColor blackColor];
    /*        X, Y axis line color         */
    _column.colorForXYLine = [UIColor darkGrayColor];
    /*    Each module of the color array, such as the A class of the language performance of the color is red, the color of the math achievement is green     */
    _column.columnBGcolorsArr = @[[UIColor greenColor],[UIColor redColor]];
    /*        Module prompt         */
    _column.xShowInfoText = self.XTitlesArr;
    /*       Start animation        */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [_column showAnimation];
    });
    
    [self.bgView addSubview:_column];
}


//>>>>>>>>>>>>>>>>>>>SCChart<<<<<<<<<<<<<<<<<<<<<<

//-(void)setDraw:(NSString *)draw{
//    _draw = draw;
//    //创建柱状图
//    if (_chartView) {
//        [_chartView removeFromSuperview];
//        _chartView = nil;
//    }
//    _chartView = [[SCChart alloc] initwithSCChartDataFrame:CGRectMake(10, 10, KScreenWidth - 20, 180) withSource:self withStyle:SCChartBarStyle];
//    [_chartView showInView:self.bgView];
//}
//
//#pragma mark - @required
////横坐标标题数组
//- (NSArray *)SCChart_xLableArray:(SCChart *)chart {
//    return self.XTitlesArr;
//}
//
////数值多重数组
//- (NSArray *)SCChart_yValueArray:(SCChart *)chart {
//    return @[self.finishedArr,self.unfinishedArr];
//}
//
//#pragma mark - @optional
////颜色数组
//- (NSArray *)SCChart_ColorArray:(SCChart *)chart {
//    return @[SCGreen,SCRed];
//}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
